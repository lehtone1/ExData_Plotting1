library(dplyr)
library(lubridate)
library(magrittr)

data_dir <- "data"
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest_file <- "data/electric_consumption.zip"

if (!dir.exists(data_dir)) {
  dir.create(data_dir)
}

if (!file.exists(dest_file)) {
  download.file(url,dest_file)
  unzip(dest_file, exdir=data_dir)
}


# FILTER DATASET

electric_consumpiton <- read.table("data/household_power_consumption.txt", header=TRUE, sep=";")
filtered_data <- filter(electric_consumpiton, Date == "1/2/2007" | Date == "2/2/2007")

# CHANGE FACTOR TO NUMERIC
col_len <- dim(electric_consumpiton)[2]
filtered_data[,3:col_len] %<>% lapply(function(x) as.numeric(as.character(x))) 

# CHAGE TIME FORMAT

date_time_paste <- paste(filtered_data$Date, filtered_data$Time)
print(head(date_time_paste))
date_time <- strptime(date_time_paste, "%d/%m/%Y %H:%M:%S")
filtered_data$Date_time <- date_time

# PLOTTING

image_dir = "images"
if (!dir.exists(image_dir)) {
  dir.create(image_dir)
}
setwd(image_dir)

# 1
png(filename="plot1.png")
hist(filtered_data$Global_active_power, col="red", main="Global Active Power", xlab="Global Active Power (kilowatts)")
dev.off()
# 2
png(filename="plot2.png")
plot(filtered_data$Date_time, filtered_data$Global_active_power, type = "l", lty = 1, xlab="", main=NULL, ylab="Global Active Power (kilowatts)")
dev.off()
# 3 
png(filename="plot3.png")
plot(filtered_data$Date_time, filtered_data$Sub_metering_1, type = "l", lty = 1, xlab="", main=NULL, ylab="Energy sub metering")
lines(filtered_data$Date_time, filtered_data$Sub_metering_2, col = "red", type = "l", lty = 1)
lines(filtered_data$Date_time, filtered_data$Sub_metering_3, col = "blue", type = "l", lty = 1)
dev.off()
# 4
png(filename="plot4.png")
par(mfrow=c(2,2))
plot(filtered_data$Date_time, filtered_data$Global_active_power, type = "l", lty = 1, main=NULL, xlab="", ylab="Global Active Power (kilowatts)")
plot(filtered_data$Date_time, filtered_data$Voltage, type = "l", lty = 1, xlab="datetime", ylab="Voltage")
plot(filtered_data$Date_time, filtered_data$Sub_metering_1, type = "l", lty = 1, xlab="", ylab="Energy sub metering")
lines(filtered_data$Date_time, filtered_data$Sub_metering_2, col = "red", type = "l", lty = 1)
lines(filtered_data$Date_time, filtered_data$Sub_metering_3, col = "blue", type = "l", lty=1)
plot(filtered_data$Date_time, filtered_data$Global_reactive_power, type = "l", lty = 1, xlab="datetime", ylab="Global_reactive_power")
dev.off()

setwd("/Users/eerolehtonen/Downloads/data_science_specialization/exploratory_data_analysis")
