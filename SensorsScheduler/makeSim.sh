#! /bin/bash


EXEC="Release/SensorsScheduler"
INIT_LAMBDA=$1
STEP_LAMBDA=$2
VOLT_BATT=$3
#OUTPUT_DIR="stats"
OUTPUT_DIR=$4
SELFDISCHARGE_LOSS=$5

if [ $# -ne 5 ]
then
	echo "Usage: $0 initLambda skipLambda"
fi

mkdir $OUTPUT_DIR

EINIT_600=23976
EINIT_1000=39960
EINIT_1400=55944
EINIT_1800=71928
EINIT_VAR="$EINIT_600 $EINIT_1000 $EINIT_1400 $EINIT_1800"
#for EINIT in ${EINIT_VAR}
#do
#	echo $EINIT
#done
#exit

for (( lambda=INIT_LAMBDA; lambda<=25; lambda+=STEP_LAMBDA ))
#for lambda in {3..25}
do
	MIN_SENSORS=`echo $(( lambda * 2 ))`
	#echo "MIN_SENSORS $MIN_SENSORS"
	
	#for sensors in {0..150..2}
	#for (( sensors=MIN_SENSORS; sensors<=150; sensors+=lambda ))
	for (( sensors=MIN_SENSORS; sensors<=120; sensors+=1 ))
	do
		if [ $sensors -lt $MIN_SENSORS ]
		then
			continue
		fi
		
		#NOW_LS=`date +"%F %T"`
		#echo "$NOW_LS s:$sensors l:$lambda"
		#continue
		
		#BATT_VAR="200 600 1000 1400 1800"
		#BATT_VAR="500 750 1000 1250 1500"
		#BATT_VAR="300 500 700"
		BATT_VAR="300"
		
		#for (( EINIT=1000; EINIT<=5000; EINIT+=1000 ))
		#for (( EINIT=1000; EINIT<=5000; EINIT+=2000 ))
		#for EINIT in ${EINIT_VAR}
		for BATT_INIT in ${BATT_VAR}
		do
			#EINIT=`echo "$BATT_INIT * 39.96" | bc -l | awk '{printf "%.0f", $0}'`
			#EINIT=`echo "$BATT_INIT * 26.64" | bc -l | awk '{printf "%.0f", $0}'`
			EINIT=`echo "$BATT_INIT * 3.6 * $VOLT_BATT" | bc -l | awk '{printf "%.0f", $0}'`
			
			#for (( EBOOT=20; EBOOT<=100; EBOOT+=20 ))
			#for (( EBOOT=20; EBOOT<=100; EBOOT+=40 ))
			for EBOOT in 7500
			do				
				#for (( EON=10; EON<=50; EON+=10 ))
				#for (( EON=10; EON<=50; EON+=20 ))
				for EON in 494
				do			
					ESTB_uW=10	
					TSLOT_VAR="1 10 60 600 900 1200"
					#TSLOT_VAR="500 750 1000"
					
					#ESTB_60=`echo $(( ESTB_uW * 60 ))`
					#ESTB_250=`echo $(( ESTB_uW * 250 ))`
					#ESTB_500=`echo $(( ESTB_uW * 500 ))`
					#ESTB_750=`echo $(( ESTB_uW * 750 ))`
					#ESTB_1000=`echo $(( ESTB_uW * 1000 ))`
					#ESTB_VAR="$ESTB_60 $ESTB_250 $ESTB_500 $ESTB_750 $ESTB_1000"

					#for (( ESTB=10; ESTB<=50; ESTB+=10 ))
					##for (( ESTB=10; ESTB<=50; ESTB+=20 ))
					##for ESTB in ${ESTB_VAR}
					for TSLOT in ${TSLOT_VAR}
					do
						ESTB=`echo $(( ESTB_uW * TSLOT ))`
						#NOW_T=`date +"%F %T"`
						#echo "$NOW_T s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB}"						
						
						NOW_LS=`date +"%F %T"`
						echo "$NOW_LS Experiment with s:$sensors l:$lambda binit:${BATT_INIT} tslot:${TSLOT} einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB}"
						
						#CLUSTERING=0
					
						#RISNOSIM=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust ${CLUSTERING} -sim 0`
						#RISSIM=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust ${CLUSTERING} -sim 1`
						
						#if [ $RISNOSIM -ne $RISSIM ]
						#then
						#	echo "Error with s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB} -> NOSIM:$RISNOSIM != SIM:$RISSIM"
						#fi
						#echo -n ""
						
						#echo -n "Nostro... "
						#RISNOSTRO=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 1 -sd 8 -ts ${TSLOT}`
						
						echo -n "Nostro (dST 0)... "
						RISNOSTRO0=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT} -stDy 0`
						
						echo -n "Nostro (dST 1)... "
						RISNOSTRO1=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT} -stDy 1`
						
						echo -n "Nostro (dST 2)... "
						RISNOSTRO2=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT} -stDy 2`
						
						echo -n "NoClust... "
						RISNOCLUST=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 0 -d 0 -sw 0 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT}`
						
						echo -n "OnlySW... "
						RISSW=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 1 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT}`
						
						echo -n "OnlyLP... "
						RISLP=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 1 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT}`
						#RISLP=0
						
						echo -n "Rand... "
						#$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -d 0 -rand 1
						RISRAND=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -d 0 -rand 1 -sd 8 -ts ${TSLOT}`
						#RISRAND=0
						
						echo -n "BestEnergy... "
						RISBESTENE=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 1 -sd ${SELFDISCHARGE_LOSS} -ts ${TSLOT} -best 1`
						
						echo "OK!"
						echo ""
						
						
						
						#RISNOSTRO_SEC=`echo $(( RISNOSTRO * TSLOT ))`
						#RISNOSTRO_MIN=`echo $(( RISNOSTRO_SEC / 60 ))`
						#RISNOSTRO_HOURS=`echo $(( RISNOSTRO_MIN / 60 ))`
						#RISNOSTRO_DAYS=`echo $(( RISNOSTRO_HOURS / 24 ))`
						
						#RISNOSTRO_SEC=`echo "$RISNOSTRO * $TSLOT" | bc -l | awk '{printf "%f", $0}'`
						#RISNOSTRO_MIN=`echo "$RISNOSTRO_SEC / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISNOSTRO_HOURS=`echo "$RISNOSTRO_MIN / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISNOSTRO_DAYS=`echo "$RISNOSTRO_HOURS / 24" | bc -l | awk '{printf "%f", $0}'`
						
						
						
						#RISNOCLUST_SEC=`echo $(( RISNOCLUST * TSLOT ))`
						#RISNOCLUST_MIN=`echo $(( RISNOCLUST_SEC / 60 ))`
						#RISNOCLUST_HOURS=`echo $(( RISNOCLUST_MIN / 60 ))`
						#RISNOCLUST_DAYS=`echo $(( RISNOCLUST_HOURS / 24 ))`
						
						#RISNOCLUST_SEC=`echo "$RISNOCLUST * $TSLOT" | bc -l | awk '{printf "%f", $0}'`
						#RISNOCLUST_MIN=`echo "$RISNOCLUST_SEC / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISNOCLUST_HOURS=`echo "$RISNOCLUST_MIN / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISNOCLUST_DAYS=`echo "$RISNOCLUST_HOURS / 24" | bc -l | awk '{printf "%f", $0}'`
						
						
						
						#RISSW_SEC=`echo $(( RISSW * TSLOT ))`
						#RISSW_MIN=`echo $(( RISSW_SEC / 60 ))`
						#RISSW_HOURS=`echo $(( RISSW_MIN / 60 ))`
						#RISSW_DAYS=`echo $(( RISSW_HOURS / 24 ))`
						
						#RISSW_SEC=`echo "$RISSW * $TSLOT" | bc -l | awk '{printf "%f", $0}'`
						#RISSW_MIN=`echo "$RISSW_SEC / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISSW_HOURS=`echo "$RISSW_MIN / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISSW_DAYS=`echo "$RISSW_HOURS / 24" | bc -l | awk '{printf "%f", $0}'`
							
							
												
						#RISLP_SEC=`echo $(( RISLP * TSLOT ))`
						#RISLP_MIN=`echo $(( RISLP_SEC / 60 ))`
						#RISLP_HOURS=`echo $(( RISLP_MIN / 60 ))`
						#RISLP_DAYS=`echo $(( RISLP_HOURS / 24 ))`
						
						#RISLP_SEC=`echo "$RISLP * $TSLOT" | bc -l | awk '{printf "%f", $0}'`
						#RISLP_MIN=`echo "$RISLP_SEC / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISLP_HOURS=`echo "$RISLP_MIN / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISLP_DAYS=`echo "$RISLP_HOURS / 24" | bc -l | awk '{printf "%f", $0}'`
						
						
						
						#RISRAND_SEC=`echo $(( RISRAND * TSLOT ))`
						#RISRAND_MIN=`echo $(( RISRAND_SEC / 60 ))`
						#RISRAND_HOURS=`echo $(( RISRAND_MIN / 60 ))`
						#RISRAND_DAYS=`echo $(( RISRAND_HOURS / 24 ))`
						
						#RISRAND_SEC=`echo "$RISRAND * $TSLOT" | bc -l | awk '{printf "%f", $0}'`
						#RISRAND_MIN=`echo "$RISRAND_SEC / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISRAND_HOURS=`echo "$RISRAND_MIN / 60" | bc -l | awk '{printf "%f", $0}'`
						#RISRAND_DAYS=`echo "$RISRAND_HOURS / 24" | bc -l | awk '{printf "%f", $0}'`
						
						#CLUST_GAIN_SEC=`echo $(( RISNOSTRO_SEC - RISNOCLUST_SEC ))`
						#CLUST_GAIN_MIN=`echo $(( RISNOSTRO_MIN - RISNOCLUST_MIN ))`
						#CLUST_GAIN_HOURS=`echo $(( RISNOSTRO_HOURS - RISNOCLUST_HOURS ))`
						#CLUST_GAIN_DAYS=`echo $(( RISNOSTRO_DAYS - RISNOCLUST_DAYS ))`
						
						
						
						#CLUST_GAIN_SEC=`echo "$RISNOSTRO_SEC - $RISNOCLUST_SEC" | bc -l | awk '{printf "%f", $0}'`
						#CLUST_GAIN_MIN=`echo "$RISNOSTRO_MIN - $RISNOCLUST_MIN" | bc -l | awk '{printf "%f", $0}'`
						#CLUST_GAIN_HOURS=`echo "$RISNOSTRO_HOURS - $RISNOCLUST_HOURS" | bc -l | awk '{printf "%f", $0}'`
						#CLUST_GAIN_DAYS=`echo "$RISNOSTRO_DAYS - $RISNOCLUST_DAYS" | bc -l | awk '{printf "%f", $0}'`
						
						#echo "Experiment with s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB} -> GAIN_SEC:${CLUST_GAIN_SEC}; GAIN_MIN:${CLUST_GAIN_MIN}; GAIN_HOURS:${CLUST_GAIN_HOURS}"
						#echo "M: Nostro: ${RISNOSTRO_MIN}; NoClust: ${RISNOCLUST_MIN}; OnlySW: ${RISSW_MIN}; OnlyLP: ${RISLP_MIN}; Rand: ${RISRAND_MIN}"
						#echo "H: Nostro: ${RISNOSTRO_HOURS}; NoClust: ${RISNOCLUST_HOURS}; OnlySW: ${RISSW_HOURS}; OnlyLP: ${RISLP_HOURS}; Rand: ${RISRAND_HOURS}"
						#echo ""
						
						
						#echo "$lambda $RISNOSTRO" >> "$OUTPUT_DIR/nostro_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						#echo "$sensors $RISNOSTRO" >> "$OUTPUT_DIR/nostro_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						#echo "$TSLOT $RISNOSTRO" >> "$OUTPUT_DIR/nostro_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						#echo "$BATT_INIT $RISNOSTRO" >> "$OUTPUT_DIR/nostro_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISNOSTRO0" >> "$OUTPUT_DIR/nostro0_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISNOSTRO0" >> "$OUTPUT_DIR/nostro0_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISNOSTRO0" >> "$OUTPUT_DIR/nostro0_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISNOSTRO0" >> "$OUTPUT_DIR/nostro0_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISNOSTRO1" >> "$OUTPUT_DIR/nostro1_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISNOSTRO1" >> "$OUTPUT_DIR/nostro1_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISNOSTRO1" >> "$OUTPUT_DIR/nostro1_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISNOSTRO1" >> "$OUTPUT_DIR/nostro1_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISNOSTRO2" >> "$OUTPUT_DIR/nostro2_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISNOSTRO2" >> "$OUTPUT_DIR/nostro2_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISNOSTRO2" >> "$OUTPUT_DIR/nostro2_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISNOSTRO2" >> "$OUTPUT_DIR/nostro2_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISNOCLUST" >> "$OUTPUT_DIR/noclust_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISNOCLUST" >> "$OUTPUT_DIR/noclust_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISNOCLUST" >> "$OUTPUT_DIR/noclust_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISNOCLUST" >> "$OUTPUT_DIR/noclust_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISSW" >> "$OUTPUT_DIR/onlysw_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISSW" >> "$OUTPUT_DIR/onlysw_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISSW" >> "$OUTPUT_DIR/onlysw_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISSW" >> "$OUTPUT_DIR/onlysw_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISLP" >> "$OUTPUT_DIR/onlylp_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISLP" >> "$OUTPUT_DIR/onlylp_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISLP" >> "$OUTPUT_DIR/onlylp_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISLP" >> "$OUTPUT_DIR/onlylp_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISRAND" >> "$OUTPUT_DIR/rand_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISRAND" >> "$OUTPUT_DIR/rand_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISRAND" >> "$OUTPUT_DIR/rand_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISRAND" >> "$OUTPUT_DIR/rand_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
						echo "$lambda $RISBESTENE" >> "$OUTPUT_DIR/bestene_s${sensors}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$sensors $RISBESTENE" >> "$OUTPUT_DIR/bestene_l${lambda}_ts${TSLOT}_bi${BATT_INIT}.data"
						echo "$TSLOT $RISBESTENE" >> "$OUTPUT_DIR/bestene_s${sensors}_l${lambda}_bi${BATT_INIT}.data"
						echo "$BATT_INIT $RISBESTENE" >> "$OUTPUT_DIR/bestene_s${sensors}_ts${TSLOT}_l${lambda}.data"
						
					done
				done
			done
		done		
	done
	
done

