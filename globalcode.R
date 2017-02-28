# install.packages("nycflights13")
# install.packages('hexbin')
# install.packages('DT')
# install.packages('shinydashboard')

rm(list = ls())

library(nycflights13)
library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(pander)
library(DT)
library(shinydashboard)

# Loading data
data(package = 'nycflights13')
flights <- data.table(flights)
weather <- data.table(weather)
airlines <- data.table(airlines)
airports <- data.table(airports)
planes <- data.table(planes)

# Merging and cleaning the dataset
airports <- select(airports, origin = faa, or_airport = name)
airlines <- rename(airlines, carriercom = name)

dat <- merge(flights, airlines,
            by.x = c("carrier"), 
            by.y = c("carrier") )

dr <- merge(dat, airports,
            by.x = c("origin"), 
            by.y = c("origin") )

airports <- select(airports, dest = origin, dest_airport = or_airport)

dt <- merge(dr, airports,
            by.x = c("dest"), 
            by.y = c("dest") )

dat <- NULL
dr <- NULL
dt <- na.omit(dt)

# Mutating the time and date variables
dt$sch_arr_hour <- as.numeric(dt$sched_arr_time)%/%100
dt$sch_arr_min <- as.numeric(dt$sched_arr_time)%%100

dt$dep_hour <- as.numeric(dt$dep_time)%/%100
dt$dep_min <- as.numeric(dt$dep_time)%%100

dt$arr_hour <- as.numeric(dt$arr_time)%/%100
dt$arr_min <- as.numeric(dt$arr_time)%%100

dt$sch_dep_hour <- as.numeric(dt$sched_dep_time)%/%100
dt$sch_dep_min <- as.numeric(dt$sched_dep_time)%%100

dt$date <- as.factor(format(strptime(dt$time_hour, format = "%Y-%m-%d")))
dt$date <- as.Date(dt$date)

dt$weekday <- as.factor(format(strptime(dt$time_hour, format = "%Y-%m-%d %H:%M"), "%A"))
# Keeping only the needed variables
dt$origin <- NULL
dt$carrier <- NULL
dt$year <- NULL
dt$month <- NULL
dt$day <- NULL
dt$tailnum <- NULL
dt$dest <- NULL
dt$hour <- NULL
dt$minute <- NULL
dt$time_hour <- NULL

dt[, weekday := weekdays(date)]

