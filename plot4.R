# produces 4 line graphs on power data
# 1. global active power
# 2. voltage
# 3. energy submetering
# 4. global reactive power

require("data.table")
library("data.table")

file_name <- "household_power_consumption.txt"

# read in the file

if (!file.exists(file_name)){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url,"asgn1.zip",method="curl")
    file_names <- unzip("asgn1.zip",list=TRUE)

    if (file_names["Name"] != file_name) {
        stop("File name not found.")
    }
    unzip("asgn1.zip")
}

# read subset of data
df <- fread(file_name, sep=";",na.strings="?")

start_date <- "1/2/2007"
end_date <- "2/2/2007"

df.subset <- subset(df, Date == start_date | Date == end_date)

df.subset$DateTime <- paste(df.subset$Date, df.subset$Time)
df.subset$Date = as.Date(df.subset$Date,format="%d/%m/%Y")
df.subset$Time = strptime(df.subset$Time, format = "%H:%M:%S")
df.subset$DateTime <- as.POSIXct(df.subset$DateTime, format="%d/%m/%Y %H:%M:%S")

# plot 4 graphs
png('plot4.png')
par(mfrow=c(2,2))

# top left - global active power over time
plot(df.subset$DateTime,
     as.numeric(df.subset$Global_active_power),
     xlab="",
     ylab="Global Active Power (kilowatts)",
     type="l")
# top right - voltage over time
plot(df.subset$DateTime,
     as.numeric(df.subset$Voltage),
     xlab="datetime",
     ylab="Voltage",
     type="l")
# bottom left - energy submetering over time
plot (df.subset$DateTime,
      as.numeric(df.subset$Sub_metering_1),
      type="n", # sets the x and y axes scales
      xlab="",
      ylab="Energy Sub Metering")

lines(df.subset$DateTime,
      as.numeric(df.subset$Sub_metering_1),
      lwd=2.5) # adds a line for Sub_metering_1

lines(df.subset$DateTime,
      as.numeric(df.subset$Sub_metering_2),
      col="red",
      lwd=2.5) # adds a line for Sub_metering_2

lines(df.subset$DateTime,
      as.numeric(df.subset$Sub_metering_3),
      col="blue",
      lwd=2.5) # adds a line for Sub_metering_3
legend("topright", # places a legend at the appropriate place
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), # puts text in the legend
       bty="n",
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       lwd=c(2.5,2.5),col=c("black","red","blue")) # gives the legend lines the correct color and width

# bottom right - glocal reactive power over time
plot(df.subset$DateTime,
     as.numeric(df.subset$Global_reactive_power),
     xlab="datetime",
     ylab="Global_reactive_power",
     type="l")
#
dev.off()
