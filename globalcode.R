install.packages("nycflights13")

rm(list = ls())

library(nycflights13)
library(shiny)
library(ggplot2)
library(dplyr)
library(data.table)
library(pander)
library(reshape2)

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
airport_comb <- dt[, list(count = .N), by = list(or_airport, dest_airport)]
weekdays_comb <- dt[, list(weekday), by = arr_delay]


# Number Plot
flight_number_title = paste("Number of flights in the given time period from", 
                            dt$or_airport, "to", dt$dest_airport)

ggplot(dt, aes(x = carriercom, fill = carriercom)) + 
  geom_bar(width = 1, colour = 'white') +
  geom_text(aes(y=..count.., label=..count..),
                   stat = "count", color = "white",
                   hjust = 1.0, size = 3) +
  theme(legend.position = "none") + 
  coord_flip() +
  xlab('Carrier Company') + 
  ggtitle(flight_number_title)

# Weekday Plot
delay_weekday_title = paste("Arrival delay from", dt$or_airport, "to", dt$dest_airport)


delay_weekday <- dt[, list(m_arr_delay = mean(arr_delay, na.rm = TRUE)), by = list(weekday, carriercom)]
ggplot(delay_weekday, aes(x = carriercom, y = weekday, fill = m_arr_delay)) +
  geom_tile() + 
  scale_fill_gradient(low = "blue", high = "yellow") +
  xlab('Carrier Company') + 
  ylab('Day of the week') + 
  ggtitle(delay_weekday_title)
