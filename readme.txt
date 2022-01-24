Battery discharge rate apps

App to calculate battery discharge or charge rate
Run as background job

1. ./battery-discharge.sh &

# Macos intel 
  creates $D-batterydischargerate.csv    csv file where $D=current-date

2. ./analyze-battery.sh 
    will run: 
      R CMD BATCH  analyze-battery.R 
         results file : analyze-battery.Rout 
         or run Rscript analyze-battery.R on terminal to get output
