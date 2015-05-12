#!/usr/bin/R --verbose --quiet

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")

torm <- ls()
remove(list = torm[!torm %in% c("nei", "scc")], torm)

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
png(filename = "plot1-2.png", width=640, height=480, units="px")
plot(totals$year, totals$total/10^6,
     xaxt = "n",
     xlab = "Year",
     ylab="Total Emissions (millions tons)",
     main = expression(PM[2.5] * " Total Emissions for all Sources"))
axis(1, at = totals$year)
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

mobile <- scc[grep("Mobile", scc$EI.Sector), ]
table(mobile$SCC.Level.One)
mobile[grep("Combustion Engines", mobile$SCC.Level.One), c("SCC", "Short.Name")]
mobile[grep("Mobile Sources", mobile$SCC.Level.One), c("SCC", "Short.Name")]

library(dplyr)

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grep("Mobile", scc$EI.Sector), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))
totals$fips <- factor(totals$fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland"))

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions), types = n())
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))
totals$type <- factor(totals$type)

library(lattice)

xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(4, 2),
       col = "blue",
       pch = 19,
       xlab = "Year of Emissions",
       ylab = "Total Emissions (tons)",
       main = expression(PM[2.5] * " Emissions from Motor Vehicle Sources"),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })