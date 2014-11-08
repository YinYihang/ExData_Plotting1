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

## plot1
png(file = "plot1.png", bg = "transparent")
hist(data$Global_active_power,col = "red",main = "Global Active Power",xlab = "Global Active Power(kilowatts)")

## copy plot1 to the png file plot1.png
##dev.copy(png,file="plot1.png",height = 480,width = 480)
dev.off()