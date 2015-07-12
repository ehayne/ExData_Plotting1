# produces 4 line graphs on power data
# 1. global active power
# 2. voltage
# 3. energy submetering
# 4. global reactive power
#
# # produces a bar graph of global active power

# getData <- function() {
require("data.table")
library("data.table")

file_name <- "household_power_consumption.txt"

# read in the file
#
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

df.subset$Date = as.Date(df.subset$Date,format="%d/%m/%Y")
df.subset$Time = strptime(df.subset$Time, format = "%H:%M:%S")

# plot 4 graphs
png('plot4.png')
par(mfrow=c(2,2))

# top left
hist(as.numeric(df.subset$Global_active_power),
     main="Global Active Power",
     xlab="Global Active Power (kilowatts)",
     ylab="Frequency",
     col="red")
# top right

# bottom left

# bottom right

#
dev.off()
