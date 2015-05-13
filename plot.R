#!/usr/bin/R --verbose --quiet

#
# Clean workspace
#

rm(list=setdiff(ls(), c("nei", "scc")))
while(dev.cur() != 1) dev.off()

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

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
png(filename = "plot1-1.png", width=480, height=480, units="px")
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
# report total emissions in millions of tons
totals <- transform(totals, total = total / 10^6)

png(filename = "plot1-2.png", width=480, height=480, units="px")
x <- with(totals, barplot(total, width = 4, names.arg = year, las = 1, yaxs = "i"))
with(totals, text(x, total, labels = round(total, 2), pos = 1, offset = 0.5))
title(xlab = "Year of Emission")
title(ylab = "Total Emissions (millions tons)")
title(main = expression(PM[2.5] * " Total Emissions for all Sources"))
dev.off()


################################################################################
# PLOT 2
################################################################################

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

#system.time({})
#user  system elapsed
#1.332   0.124   1.456 55
nei <- readRDS("data/summarySCC_PM25.rds")
totals <- aggregate(Emissions ~ year, data = subset(nei, fips == "24510"), sum)
lmfit <- lm(Emissions ~ year, totals)
png(filename = "plot2-1.png", width=640, height=480, units="px")
plot(totals$year, totals$Emissions,
     xaxt = "n",
     xlab = "Year",
     ylab="Total Emissions (tons)",
     main = expression(PM[2.5] * " Total Emissions for Baltimore City, Maryland"))
axis(1, at = totals$year)
abline(lmfit, lty = 3, lwd = 2)
dev.off()

################################################################################
# PLOT 3
################################################################################

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable:
#
# (1) Which of these four sources have seen decreases in emissions from
#     1999–2008 for Baltimore City?
#
# (2) Which have seen increases in emissions from 1999–2008?*
#
# Baltimore City, Maryland: `fips` == "24510"



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

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grep("Mobile", scc$EI.Sector), "SCC"])

library(dplyr)

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions))
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))

library(lattice)

png(filename = "plot6-1.png", width = 640, height = 480, units = "px")
xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(4, 2),
       col = "blue",
       pch = 19,
       xlab = "Year of Emissions",
       ylab = "Total Emissions (tons)",
       main = expression(PM[2.5] * " Emissions from Motor Vehicle Sources"),
       scales = list(x = list(at = totals$year, labels = totals$year)),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })
dev.off()
