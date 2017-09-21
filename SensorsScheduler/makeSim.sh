#! /bin/bash

OUTPUT_DIR="stats"
EXEC="Release/SensorsScheduler"
N_RUNS=$1

for lambda in {3..25}
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
		
		NOW_LS=`date +"%F %T"`
		echo "$NOW_LS s:$sensors l:$lambda"
		
		#for (( EINIT=1000; EINIT<=5000; EINIT+=1000 ))
		for (( EINIT=1000; EINIT<=5000; EINIT+=2000 ))
		do
			#for (( EBOOT=20; EBOOT<=100; EBOOT+=20 ))
			for (( EBOOT=20; EBOOT<=100; EBOOT+=40 ))
			do				
				#for (( EON=10; EON<=50; EON+=10 ))
				for (( EON=10; EON<=50; EON+=20 ))
				do				
					#for (( ESTB=10; ESTB<=50; ESTB+=10 ))
					for (( ESTB=10; ESTB<=50; ESTB+=20 ))
					do
						#NOW_T=`date +"%F %T"`
						#echo "$NOW_T s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB}"
						
						#CLUSTERING=0
					
						#RISNOSIM=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust ${CLUSTERING} -sim 0`
						#RISSIM=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust ${CLUSTERING} -sim 1`
						
						#if [ $RISNOSIM -ne $RISSIM ]
						#then
						#	echo "Error with s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB} -> NOSIM:$RISNOSIM != SIM:$RISSIM"
						#fi
						#echo -n ""
						
						RISNOSTRO=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -sim 0`
						RISNOCLUST=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 0 -d 0 -sw 0 -lp 0 -sim 0`
						RISSW=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 1 -lp 0 -sim 1`
						RISLP=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 1 -sim 1`
						RISRAND=`$EXEC -l ${lambda} -s ${sensors} -ei ${EINIT} -eb ${EBOOT} -eo ${EON} -es ${ESTB} -clust 1 -d 0 -sw 0 -lp 0 -rand 1 -sim 1`
						
						echo "Experiment with s:$sensors l:$lambda einit:${EINIT} eboot:${EBOOT} eon:${EON} estb:${ESTB}"
						echo "Nostro: ${RISNOSTRO}; NoClust: ${RISNOCLUST}; OnlySW: ${RISSW}; OnlyLP: ${RISLP}; Rand: ${RISRAND}"
						echo ""
						
					done
				done
			done
		done
		
		
		
	done
	
done

