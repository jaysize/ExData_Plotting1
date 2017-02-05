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


# 5. Plot 4
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(powerdata, {
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Global_Active_PowerKW, type = "l", 
       xlab = NULL, ylab = "Global Active Power")
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Voltage, type = "l", xlab = NULL, ylab = "Voltage")
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Sub_metering_1, type = "l",
       yaxp  = c(0, 40, 4), xlab = NULL, ylab = "Energy Sub Metering")
  lines(date_time,Sub_metering_2,col="red")
  lines(date_time,Sub_metering_3,col="blue")
  legend("topright", lty = 1, 
         col = c("black","red", "blue"), 
         legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Global_reactive_power/500, type = "l", 
       xlab = "date_time", ylab = "Global_reactive_power")
})

# 6. Print to png file
png(filename="plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2), mar = c(4, 4, 2, 1), oma = c(0, 0, 2, 0))
with(powerdata, {
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Global_Active_PowerKW, type = "l", 
       xlab = NULL, ylab = "Global Active Power")
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Voltage, type = "l", xlab = NULL, ylab = "Voltage")
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Sub_metering_1, type = "l",
       yaxp  = c(0, 40, 4), xlab = NULL, ylab = "Energy Sub Metering")
  lines(date_time,Sub_metering_2,col="red")
  lines(date_time,Sub_metering_3,col="blue")
  legend("topright", lty = 1, 
         col = c("black","red", "blue"), 
         legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"))
  
  par(mar=c(3.1,4.1,3.1,2.1))
  plot(date_time, Global_reactive_power/500, type = "l", 
       xlab = "date_time", ylab = "Global_reactive_power")
})
dev.off()