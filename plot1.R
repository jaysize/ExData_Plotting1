library(plyr)
library(dplyr)
library(data.table)
library(downloader)
library(lubridate)

# 1. Read the entire data set from the UCI website
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, "UCI_Power_Dataset.zip")
unzip("UCI_Power_Dataset.zip")
powerdat <- read.csv("household_power_consumption.txt", sep = ";", header = TRUE)

# 2. Combine and filter date/time columns.
powerdat$date_time = dmy_hms(paste(powerdat$Date, powerdat$Time),tz = "UTC")
Date1<-as.POSIXct("2007-02-01 00:01:00", tz = "UTC")
Date2<-as.POSIXct("2007-02-02 23:59:00", tz = "UTC")
powerdata <- subset(powerdat, date_time >= Date1 & date_time <= Date2)

# 3. Convert the other columns to numeric.
namedat <- names(powerdata[,3:9])
for(i in namedat){
  powerdata[[i]] <- as.numeric(powerdata[[i]])
}

# 4. Convert Active power to KW
powerdata$Global_Active_PowerKW <- (as.numeric(powerdata$Global_active_power))/500


# 5. Plot 1
hist(powerdata$Global_Active_PowerKW, col='red', 
     # breaks = c(0,0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0),
     breaks = 16,
     # xlim = range(0,6),
     main = "Global Active Power",
     xlab = "Global Active Power (Kilowatts)",
     ylab = "Frequency")

# 6. Print to png file
png(filename="plot1.png", width = 480, height = 480)
hist(powerdata$Global_Active_PowerKW, col='red',
     breaks = 20,
     main = "Global Active Power",
     xlab = "Global Active Power (Kilowatts)",
     ylab = "Frequency")
dev.off()