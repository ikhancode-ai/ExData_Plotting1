# ---- Data loader helper (used in each script) ----
# Expected file in the same folder:
#   household_power_consumption.txt  (preferred)
# OR
#   household_power_consumption.txt.gz
datafile_txt <- "household_power_consumption.txt"
datafile_gz  <- "household_power_consumption.txt.gz"

read_power_data <- function() {
  if (file.exists(datafile_txt)) {
    con <- datafile_txt
  } else if (file.exists(datafile_gz)) {
    con <- gzfile(datafile_gz, open = "rt")
  } else {
    stop("Dataset not found. Put 'household_power_consumption.txt' (or .txt.gz) in this same folder.")
  }

  df <- read.table(
    con,
    header = TRUE,
    sep = ";",
    na.strings = "?",
    stringsAsFactors = FALSE
  )

  # Subset for 2007-02-01 and 2007-02-02 (stored as d/m/YYYY in the file)
  df <- df[df$Date %in% c("1/2/2007", "2/2/2007"), ]

  # Build datetime
  df$datetime <- strptime(paste(df$Date, df$Time), format = "%d/%m/%Y %H:%M:%S")

  df
}


# ---- Plot 4 ----
df <- read_power_data()

df$Global_active_power <- as.numeric(df$Global_active_power)
df$Global_reactive_power <- as.numeric(df$Global_reactive_power)
df$Voltage <- as.numeric(df$Voltage)
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3)

png("plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2), mar = c(4, 4, 2, 1))

plot(
  df$datetime,
  df$Global_active_power,
  type = "l",
  xlab = "",
  ylab = "Global Active Power"
)

plot(
  df$datetime,
  df$Voltage,
  type = "l",
  xlab = "datetime",
  ylab = "Voltage"
)

plot(
  df$datetime,
  df$Sub_metering_1,
  type = "l",
  xlab = "",
  ylab = "Energy sub metering"
)
lines(df$datetime, df$Sub_metering_2, col = "red")
lines(df$datetime, df$Sub_metering_3, col = "blue")
legend(
  "topright",
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  col = c("black", "red", "blue"),
  lty = 1,
  bty = "n"
)

plot(
  df$datetime,
  df$Global_reactive_power,
  type = "l",
  xlab = "datetime",
  ylab = "Global_reactive_power"
)

dev.off()
