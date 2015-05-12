#!/usr/bin/R --verbose --quiet

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")

################################################################################
# PLOT 1
################################################################################

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

nei <- readRDS("data/summarySCC_PM25.rds")

#system.time({})
#user  system elapsed
#8.700   0.292   8.984
totals <- aggregate(list(total = nei$Emissions), by = list(year = nei$year), sum)
png(filename = "plot1-1.png", width=640, height=480, units="px")
plot(totals$year, totals$total/10^6,
     xaxt = "n",
     xlab = "Year",
     ylab="Total Emissions (millions tons)",
     main = expression(PM[2.5] * " Total Emissions for all Sources"))
axis(1, at = totals$year)
dev.off()

#system.time({})
#user  system elapsed
#1.952   0.008   1.958
library(dplyr)
totals <- nei %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))
png(filename = "plot1-1.png", width=640, height=480, units="px")
plot(totals$year, totals$total/10^6,
     xaxt = "n",
     xlab = "Year",
     ylab="Total Emissions (millions tons)",
     main = expression(PM[2.5] * " Total Emissions for all Sources"))
axis(1, at = totals$year)
dev.off()

################################################################################
# PLOT 6
################################################################################

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

mobile <- scc[grep("Mobile", scc$EI.Sector), ]
table(mobile$SCC.Level.One)
mobile[grep("Combustion Engines", mobile$SCC.Level.One), c("SCC", "Short.Name")]
mobile[grep("Mobile Sources", mobile$SCC.Level.One), c("SCC", "Short.Name")]
