# Gnuplot script file for plotting data in file "force.dat"
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
#set title "Link Budget"
set ylabel "Correlation"
set xlabel "Sensors number"
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


set xtics ("6" 0, "9" 1, "12" 2, "15" 3, "18" 4)

set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L3-PatternBlack.eps"

plot "data/histogram3.data" using 1 t "Optimal" fs pattern 1 lc 7, \
"data/histogram3.data" using 2 t "Algo1" fs pattern 7 lc 7, \
"data/histogram3.data" using 3 t "Approx" fs pattern 4 lc 7, \
"data/histogram3.data" using 4 t "k-means" fs pattern 5 lc 7, \
"data/histogram3.data" using 5 t "Random" fs pattern 6 lc 7



set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L3-PatternColor.eps"


plot "data/histogram3.data" using 1 t "Optimal" fs pattern 3 lc 7, \
"data/histogram3.data" using 2 t "Algo1" fs pattern 1 lc 2, \
"data/histogram3.data" using 3 t "Approx" fs pattern 5 lc 3, \
"data/histogram3.data" using 4 t "k-means" fs pattern 4 lc 1, \
"data/histogram3.data" using 5 t "Random" fs pattern 7 lc 4



set style fill solid 0.80 noborder
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L3-BlockColor.eps"

plot "data/histogram3.data" using 1 t "Optimal" lc 1, \
"data/histogram3.data" using 2 t "Algo1" lc 2, \
"data/histogram3.data" using 3 t "Approx" lc 3, \
"data/histogram3.data" using 4 t "k-means" lc 4, \
"data/histogram3.data" using 5 t "Random" lc 5








set xtics ("8" 0, "12" 1, "16" 2, "20" 3, "24" 4)

set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L4-PatternBlack.eps"

plot "data/histogram4.data" using 1 t "Optimal" fs pattern 1 lc 7, \
"data/histogram4.data" using 2 t "Algo1" fs pattern 7 lc 7, \
"data/histogram4.data" using 3 t "Approx" fs pattern 4 lc 7, \
"data/histogram4.data" using 4 t "k-means" fs pattern 5 lc 7, \
"data/histogram4.data" using 5 t "Random" fs pattern 6 lc 7



set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L4-PatternColor.eps"


plot "data/histogram4.data" using 1 t "Optimal" fs pattern 3 lc 7, \
"data/histogram4.data" using 2 t "Algo1" fs pattern 1 lc 2, \
"data/histogram4.data" using 3 t "Approx" fs pattern 5 lc 3, \
"data/histogram4.data" using 4 t "k-means" fs pattern 4 lc 1, \
"data/histogram4.data" using 5 t "Random" fs pattern 7 lc 4



set style fill solid 0.80 noborder
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L4-BlockColor.eps"

plot "data/histogram4.data" using 1 t "Optimal" lc 1, \
"data/histogram4.data" using 2 t "Algo1" lc 2, \
"data/histogram4.data" using 3 t "Approx" lc 3, \
"data/histogram4.data" using 4 t "k-means" lc 4, \
"data/histogram4.data" using 5 t "Random" lc 5













set xtics ("10" 0, "15" 1, "20" 2, "25" 3, "30" 4)

set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L5-PatternBlack.eps"

plot "data/histogram5.data" using 1 t "Optimal" fs pattern 1 lc 7, \
"data/histogram5.data" using 2 t "Algo1" fs pattern 7 lc 7, \
"data/histogram5.data" using 3 t "Approx" fs pattern 4 lc 7, \
"data/histogram5.data" using 4 t "k-means" fs pattern 5 lc 7, \
"data/histogram5.data" using 5 t "Random" fs pattern 6 lc 7



set style fill solid border -1
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L5-PatternColor.eps"


plot "data/histogram5.data" using 1 t "Optimal" fs pattern 3 lc 7, \
"data/histogram5.data" using 2 t "Algo1" fs pattern 1 lc 2, \
"data/histogram5.data" using 3 t "Approx" fs pattern 5 lc 3, \
"data/histogram5.data" using 4 t "k-means" fs pattern 4 lc 1, \
"data/histogram5.data" using 5 t "Random" fs pattern 7 lc 4



set style fill solid 0.80 noborder
set terminal postscript eps enhanced color font "Times"
set output "histogramCorrelation-L4-BlockColor.eps"

plot "data/histogram5.data" using 1 t "Optimal" lc 1, \
"data/histogram5.data" using 2 t "Algo1" lc 2, \
"data/histogram5.data" using 3 t "Approx" lc 3, \
"data/histogram5.data" using 4 t "k-means" lc 4, \
"data/histogram5.data" using 5 t "Random" lc 5









