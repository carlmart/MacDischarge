#!/bin/sh
# battery-discharge.sh   # run to start analyzing battery discharge rate as background job &
# Macos intel 
# creates $D-batterydischargerate.csv    csv file where $D=current-date
# files next to run is analyze-battery.sh which will run: R CMD BATCH  analyze-battery.R 
# results file : analyze-battery.Rout 
# or run Rscript analyze-battery.R on terminal to get output
# echo -n "$D,$T,$B,"               # no newline at end
# /Users/ceo/Desktop/macos/git/apps/MacDischarge
# P="/Users/ceo/apps/MacDischarge/data/" # Data Path
P="/Users/ceo/Desktop/macos/git/apps/MacDischarge/data/" # Data Path
  getFilename () {
    D=`date +%Y-%m-%d`                     # Day
    F="$P/$D-bdrate.csv"                   # output file  <DATE>-bdrate.csv
}

  append2File () {
     T=`date +%H:%M:%S`                    # Time
     B=`pmset -g batt| cut -c34-36`        # battery percentage left
     B1=$(echo $B | tr -d '\n')            # remove the newline character
     B2=$(echo $B1 | tr -d '%')            # remove the % char
     echo "$D,$T,$B2"  >> $F               # append to file
}

N=300                                      # 5m/300sec 15m/900sec


while True
  do
    D=`date +%Y-%m-%d`                      # Day
    F="$P/$D-bdrate.csv"               # output file  <DATE>-bdrate.csv
   if [ -f $F ]; then
     append2File 
     sleep $N 
   else
     echo "DATE,TIME,DISRATE"> $F          # start new file
     append2File 
     sleep $N 
   fi
  done


