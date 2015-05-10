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

nei <- readRDS("data/summarySCC_PM25.rds")

#
# Summarise
#

# make sure we have packages installed to run analysis
if (!require("dplyr")) {
    stop("Required package dplyr missing")
}

# aggregate emission by year
# check using (much slower than dplyr)
# totals <- aggregate(list(total = nei$Emissions), by = list(year = nei$year), sum)
library(dplyr)
totals <- nei %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

# report total emissions in millions of tons
totals$total <- totals$total / 10^6

#
# Plot
#

# plot total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, 2008
png(filename = "plot1.png", width=480, height=480, units="px")
x <- with(totals, barplot(total, width = 4, names.arg = year, las = 1, yaxs = "i"))
text(x, totals$total, labels = round(totals$total, 2), pos = 1, offset = 0.5)
title(xlab = "Year of Emission")
title(ylab = "Millons tons")
title(main = expression(PM[2.5] * " Emission totals for all sources"))
dev.off()

#EOF
