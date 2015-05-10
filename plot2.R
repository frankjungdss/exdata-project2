#!/usr/bin/R --verbose --quiet

# PLOT 1

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (`fips` == "24510") from 1999 to 2008?

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

nei <- readRDS("data/summarySCC_PM25.rds")

#
# Summarise
#

# make sure we have packages installed to run analysis
if (!require("dplyr")) {
    stop("Required package dplyr missing")
}

# aggregate emission by year
library(dplyr)
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

# use linear regression model for trend analysis
lmfit <- lm(total ~ year, totals)

#
# Plot
#

# plot total emissions from PM2.5 in the Baltimore City, Maryland from 1999 to 2008
png(filename = "plot2.png", width=480, height=480, units="px")
with(totals, plot(year, total, xlab="", ylab="", xaxt = "n", pch = 19))
with(totals, axis(1, at = year))
abline(lmfit, col = "red", lty = 3, lwd = 2)
title(xlab = "Year of Emissions")
title(ylab = "Emissions Total (tons)")
title(main = expression(PM[2.5] * " Total emissions for Baltimore City, Maryland from all sources"))
dev.off()

#EOF
