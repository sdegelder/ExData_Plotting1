#This script should be placed in the same folder as the household_power_consumption.txt file
#and this folder should be set as your work directory

#reading a first subset of the household_power_consumption.txt file
#by starting at the first row with Feb 1, 2007 row
require(data.table)
first.subset <- fread("household_power_consumption.txt",sep=";",header=FALSE,na.strings=c("?"),verbose=FALSE,skip="1/2/2007",colClasses=c("character","character","character","character","character","character","character","character","character"))

#subseting our dataset to only keep data for Feb 1 and 2, 2007
data.set <- subset(first.subset, (V1 == "1/2/2007")|(V1 == "2/2/2007"))

#adding clean variable names
setnames(data.set,c("V1","V2","V3","V4","V5","V6","V7","V8","V9"),c("Date","Time","Global_active_power","Global_reactive_power","Voltage","Global_intensity","Sub_metering_1","Sub_metering_2","Sub_metering_3"))

#merging Date and Time columns, and converting dates from char to date format
new.date <- paste(as.Date(data.set$Date,"%d/%m/%Y"),data.set$Time,sep=" ")
new.date <- as.character(new.date)
#converting date and time to POSIXct format
new.date <- as.POSIXct(new.date, tz = "")

#merging our new date column with our dataset
data.set <- cbind(new.date,data.set)
#removing previous date and time column
data.set <- subset(data.set, select=-c(Date,Time))
setnames(data.set,"new.date","Date")

#generating the plot1 histogram on screen
data.set$Global_active_power <- as.numeric(data.set$Global_active_power)
hist(data.set$Global_active_power,col = "red", main = "Global Active Power", xlab="Global Active Power (kilowatts)")

#create png file with this histogram
dev.copy(png,file="plot1.png")
dev.off()