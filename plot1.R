#!/usr/bin/R --verbose --quiet

# PLOT 1

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#
# Get data
#

# download data
if (!file.exists("data/NEI_data.zip")) {
    print("Downloading data ...")
    fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fileUrl, destfile = "NEI_data.zip", method = "curl", quiet = TRUE)
    Sys.time()
}

# unzip data
if (!file.exists("data/Source_Classification_Code.rds") || !file.exists("data/summarySCC_PM25.rds")) {
    unzip("data/NEI_data.zip", exdir="data", overwrite = TRUE)
}

#
# Load data
#

data <- readRDS("data/summarySCC_PM25.rds")
data <- readRDS("data/Source_Classification_Code.rds")

#
# Plot
#

# plot 1 - plot total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, 2008
# png(filename = "plot1.png", width=480, height=480, units="px")
hist()
# dev.off()

#EOF
