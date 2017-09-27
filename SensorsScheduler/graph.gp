set autoscale
unset log
unset label
set xtic auto
#set xtic 3
#set ytic 1
#set y2tic auto

#set logscale y

#set title "Title"
#set xlabel "Simulation time (min)"
set ylabel "Lifetime"

set xlabel font ",22"
set ylabel font ",22"


#set xrange [0 : 15]
#set yrange [0 : 100]


#Legend
set key bottom left
#set key top center
set key font ",22"
set key spacing 1.75
set key width 12
#set key outside

set terminal postscript eps enhanced color font "Times"


#set yrange [0 : 0.1]
#do for [la=3:12] {
#	outfile = sprintf('correlation-lambda%i.eps', la)
#	infileAlgo1 = sprintf('stats/algo1corr_OK_l%i.data', la)
#	infileOpt = sprintf('stats/optcorr_OK_l%i.data', la)
#	infileRand = sprintf('stats/randcorr_OK_l%i.data', la)
#	set output outfile
#	set xlabel "Sensors number"
#	plot \
#	infileAlgo1 using 1:2 with linespoints t "Algo1", \
#	infileOpt using 1:2 with lines t "Opt", \
#	infileRand using 1:2 with lines t "Random"
#}

set key top left

#set yrange [0 : 0.06]
#set xrange [0 : 120]

set ylabel "Lifetime (days)"
#set logscale y

set output "lt-l4_ts1_bi300.eps"
set xlabel "Sensors number"
# calculus: ((((val * ts=60)sec / 60)min / 60)hours / 24)days = (val / 1440)days
plot \
"stats/nostro0_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "Nostro0" lw 4, \
"stats/nostro1_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "Nostro1" lw 4, \
"stats/noclust_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "NoClust" lw 4, \
"stats/onlysw_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "OnlySW" lw 4, \
"stats/onlylp_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "OnlyLP" lw 4, \
"stats/rand_l4_ts1_bi300.data" using 1:(($2*1)/86400) with lines t "Random" lw 4


set output "lt-l4_ts600_bi300.eps"
set xlabel "Sensors number"
# calculus: ((((val * ts=60)sec / 60)min / 60)hours / 24)days = (val / 1440)days
plot \
"stats/nostro0_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "Nostro0" lw 4, \
"stats/nostro1_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "Nostro1" lw 4, \
"stats/noclust_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "NoClust" lw 4, \
"stats/onlysw_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "OnlySW" lw 4, \
"stats/onlylp_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "OnlyLP" lw 4, \
"stats/rand_l4_ts600_bi300.data" using 1:(($2*6)/864) with lines t "Random" lw 4








