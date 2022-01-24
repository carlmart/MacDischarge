#!/usr/local/bin/Rscript
# run on terminal with Rscript analyze-battery.R
# R CMD BATCH analyze-battery.R | run as batch file with output analyze-battery.Rout
# battery-discharge.sh is the data log creator
# DATE,TIME,DISRATE
# /Users/ceo/apps/MacDischarge/$D-bdrate.csv
# install and load libs : install.packages("chron")
# https://www.youtube.com/watch?v=jWjqLW-u3hc&ab_channel=DataSchool

#setwd("/Users/ceo/apps/MacDischarge/")
setwd("/Users/ceo/Desktop/macos/git/apps/MacDischarge")
suppressMessages(library(dplyr))    # 5 basic verbs: filter,select,arrange,mutate,summarise + group_by
library(chron)     # converts time to seconds
library(stringr)   # remove whitespace
suppressMessages(library(tidyverse)) # includes ggplot2
dat = "data/"                           # data directory
d1 = format(Sys.Date(),"%Y-%m-%d")      # date   Sys.Date()
f1 = toString(d1)                       # convert date to string
f2 = "-bdrate.csv"                     # string variable
fname = paste(dat,f1 ,f2)  
flname = str_trim(fname)
fname = str_replace_all(flname, fixed(" "), "")  # clear all spaces
#print(fname)
# example data/2021-02-22-bdrate.csv


discharge_rate = read.csv(
                #file = '2021-02-22-batterydischargerate.csv',
                file = fname,
                strip.white = TRUE,
                sep = ','
                )

# https://stackoverflow.com/questions/29067375/r-convert-hoursminutesseconds
# create a new column of seconds 
getSeconds <- function(n) {
  i = as.numeric(times(n))
  s = 60 * 24 * i
  s = as.integer(s)
  return(s)
}

# DATE,TIME,DISRATE
# creates a new dataframe dsr
dsr <- discharge_rate %>%
   select(DATE,TIME,DISRATE)  %>%
   mutate(SECONDS = getSeconds(TIME) )  # add SECONDS COLUMN
   # write.csv(.,file = "output.csv")

start_second <- dsr %>%
    select(SECONDS) %>%
    filter(row_number()==1)

start_second
min_change <- function(n){
  x = n - as.integer(start_second)
  x = as.integer(x)
  return(x)
}

rate_of_change <- function(discharge_rate){
# cat ("-------- Creating file DTSD-output.csv-----------\n")
# DATE,TIME,DISRATE,MINUTES
dsr <- discharge_rate %>%
   select(DATE,TIME,DISRATE)  %>%
   mutate(SECONDS = getSeconds(TIME) )  # add SECONDS COLUMN
x <-dsr %>%  
   select(DATE,TIME,SECONDS,DISRATE)  %>%
   mutate(MINUTES = min_change(SECONDS))
   # x   # print to terminal
   write.csv(x,file = "DTSD-output.csv")
   return(x)
}
#  mutate(PCTCHANGE = (SECONDS/lag(SECONDS) -1) * 100) %>%

png_create <- function(x) {
#cat ("---------- Creating Date-BatteryDischargeRate.png ---------\n")
da = format(Sys.Date(),"%Y-%m-%d")      # date   Sys.Date()
fa = toString(da)                       # convert date to string
fb = "-BatteryDischargeRate.png"                    # string variable
fggname = paste(fa ,fb)
fggname = str_trim(fggname)
fggname = str_replace_all(fggname, fixed(" "), "")  # clear all spaces
png(filename=fggname)  # get todays name
x %>%
    select(DISRATE,MINUTES)  %>%
    arrange(desc(DISRATE)) %>%
    ggplot( aes(x=MINUTES, y=DISRATE)) + geom_point(size=2,shape=23) +
    ggtitle("MacOS Battery Discharge Rate") +
    xlab("Minutes") + ylab("Battery Discharge Percentage")
dev.off()
}

# ---- testing ---
# https://www.youtube.com/watch?v=_7J6BbDgqrA&ab_channel=TechAnswers88
x <- rate_of_change(discharge_rate)   # create a csv file of data
# png_create(x)  # create a png image file
x

