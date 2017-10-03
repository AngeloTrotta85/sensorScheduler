# Gnuplot script file for plotting data in file "force.dat"
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
#set title "Link Budget"
set ylabel "Lifetime (days)"
set xlabel "t_{slot}"
set xlabel font ",22"
set ylabel font ",22"

#LEGEND PARAMETERS
set key bottom center
#set key at 75,45
#set key box
set key font ",22"
set key spacing 3.5
set key outside
set key horizontal 
set key maxrows 2
#set key width 12
set key height 0.9

#set style fill solid border -1
#set style fill solid 0.80 noborder
set style histogram cluster gap 2
set style data histogram

set offset -0.5,-0.4,0,0


#set xrange [-1 : 4.5]
#set yrange [0 : 100]
#set yrange [0 : 1800]
#set yrange [0 : 35]
#set xtics ("0" 0, "10" 1, "20" 2, "30" 3, "40" 4, "50" 5, "100" 6)
#set xtics ("0" 0, "25" 1, "50" 2, "75" 3, "100" 4)
#set xtics ("50" 0, "75" 1, "100" 2, "125" 3, "150" 4)


set xtics ("1" 0, "10" 1, "60" 2, "600" 3, "900" 4, "1200" 5)

set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S60-L3-PatternBlack.eps"

plot "data/histogram-s60-l3.data" using ($1/86400) t "Algo2" fs pattern 1 lc 7, \
"data/histogram-s60-l3.data" using ($2/86400) t "Only-SW" fs pattern 7 lc 7, \
"data/histogram-s60-l3.data" using ($3/86400) t "Only-LP" fs pattern 4 lc 7, \
"data/histogram-s60-l3.data" using ($4/86400) t "Random" fs pattern 5 lc 7



set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S60-L3-PatternColor.eps"


plot "data/histogram-s60-l3.data" using ($1/86400) t "Algo2" fs pattern 3 lc 7, \
"data/histogram-s60-l3.data" using ($2/86400) t "Only-SW" fs pattern 1 lc 2, \
"data/histogram-s60-l3.data" using ($3/86400) t "Only-LP" fs pattern 5 lc 3, \
"data/histogram-s60-l3.data" using ($4/86400) t "Random" fs pattern 4 lc 1



set style fill solid 0.80 noborder
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S60-L3-BlockColor.eps"

plot "data/histogram-s60-l3.data" using ($1/86400) t "Algo2" lc 1, \
"data/histogram-s60-l3.data" using ($2/86400) t "Only-SW" lc 2, \
"data/histogram-s60-l3.data" using ($3/86400) t "Only-LP" lc 3, \
"data/histogram-s60-l3.data" using ($4/86400) t "Random" lc 4













set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S50-L6-PatternBlack.eps"

plot "stats/nostro2_s50_l6_bi300.data" using (($2*$1)/86400) t "Algo2" fs pattern 1 lc 7, \
"stats/onlysw_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-SW" fs pattern 7 lc 7, \
"stats/onlylp_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-LP" fs pattern 4 lc 7, \
"stats/rand_s50_l6_bi300.data" using (($2*$1)/86400) t "Random" fs pattern 5 lc 7



set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S50-L6-PatternColor.eps"


plot "stats/nostro2_s50_l6_bi300.data" using (($2*$1)/86400) t "Algo2" fs pattern 3 lc 7, \
"stats/onlysw_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-SW" fs pattern 1 lc 2, \
"stats/onlylp_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-LP" fs pattern 5 lc 3, \
"stats/rand_s50_l6_bi300.data" using (($2*$1)/86400) t "Random" fs pattern 4 lc 1



set style fill solid 0.80 noborder
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-S50-L6-BlockColor.eps"

plot "stats/nostro2_s50_l6_bi300.data" using (($2*$1)/86400) t "Algo2" lc 1, \
"stats/onlysw_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-SW" lc 2, \
"stats/onlylp_s50_l6_bi300.data" using (($2*$1)/86400) t "Only-LP" lc 3, \
"stats/rand_s50_l6_bi300.data" using (($2*$1)/86400) t "Random" lc 4







