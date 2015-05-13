#!/usr/bin/R --verbose --quiet

# PLOT 6

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

#
# Summarise
#

library(dplyr)

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grep("Mobile", scc$EI.Sector), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions), types = n())
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))
totals$type <- factor(tolower(totals$type))

#
# Plot
#

library(lattice)

png(filename = "plot6.png", width = 640, height = 480, units = "px")
xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(4, 2),
       col = "blue",
       pch = 19,
       xlab = "Year of Emissions",
       ylab = "Total Emissions (tons)",
       main = expression(PM[2.5] * " Emissions from motor vehicle sources for selected locations"),
       scales = list(x = list(at = totals$year, labels = totals$year)),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })
dev.off()

#EOF
