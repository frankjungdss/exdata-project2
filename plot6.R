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
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))
totals$fips <- factor(totals$fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland"))

#
# Plot
#

library(lattice)

png(filename = "plot6.png", width = 640, height = 480, units = "px")
xyplot(total ~ year | fips,
       data = totals,
       layout = c(2, 1),
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

#EOF
