## entireData <- read.table("household_power_consumption.txt",head = TRUE,sep = ";",na.strings = "?")
## entireData$Date <- as.character(as.Date(entireData$Date,"%d/%m/%Y"))
## data <- subset(entireData,entireData$Date %in% c("2007-02-01","2007-02-02"))
## you can work like this to get the plot data , read the entire dataset and subset it
## but it's slower than the  below method

## Read the first 5 rows of data and you can see that the data is stored by minutes
## eg. 1 minute 1 row ,and store the column name
firstdata <- read.table("household_power_consumption.txt",head = TRUE,nrows = 5,sep = ";",na.strings = "?")
name <- names(firstdata)

## Calculate the row numbers that you should skip,because you just want the rows that 
## date between 2007-02-01 and 2007-02-02

## Read the first data's Date and then transform it to the POSIXct class 
firstDate <- as.character(firstdata$Date[1])
rowStartDate <- strptime(firstDate,"%d/%m/%Y")

## Transform the startdate and enddate to class POSIXct, according to the instrustion, 
## they're 2007-02-01 and 2007-02-02 
startDate <- as.POSIXct("2007-02-01")
endDate <- as.POSIXct("2007-02-03")

## startDate - rowStartDate is the days that you should skip, then data is stored by
## minutes, so transform the days to minutes, the result is the number of rows that
## you should skip , because the first data is from 17:24:00,  you should minus 
## (17 * 60 + 24) so that your data is start at 2007-02-01 00:00:00
skipRowNumbers <- as.numeric(startDate - rowStartDate) * 24 * 60 - 17 * 60 - 24

## Calculate the rows number that you should read
readRowNumbers <- (endDate - startDate) * 24 * 60

## Read the data from 2007-02-01 00:00:00 to 2007-02-02 23:59:00 and reset the column name
data <- read.table("household_power_consumption.txt",head = TRUE,nrows = readRowNumbers,skip = skipRowNumbers,sep = ";",na.strings = "?")
colnames(data) <- name

data$Date <- as.Date(data$Date,format = "%d/%m/%Y")
concat <- paste(data$Date,data$Time,sep = " ")
totime <- strptime(concat,"%Y-%m-%d %H:%M:%S")

## copy plot2 to the png file plot2.png , i use png() instead of dev.copy()
png(file = "plot3.png", bg = "transparent")
plot(totime,data$Sub_metering_1,type = "l",xlab = "",ylab="Energy sub metering",yaxt = "n")
lines(totime,data$Sub_metering_2,col = "orange")
lines(totime,data$Sub_metering_3,col = "blue")
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty = 1,col = c("black","orange","blue"))
## dev.copy(png,file="plot3.png",height = 480,width = 480)
dev.off()
