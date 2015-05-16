#!/usr/bin/R --verbose --quiet

# PLOT 6c

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)
library(lattice)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions), types = n())
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))
totals$type <- factor(tolower(totals$type))

# lattice
png(filename = "plot6c.png", width = 640, height = 480, units = "px")
attach(totals)
xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(3, 2),
       col = "blue",
       pch = 19,
       xlab = "Year",
       ylab = "Emissions (Tons)",
       main = expression(PM[2.5] * " Emissions from Motor Vehicle Sources for Selected Locations"),
       scales = list(x = list(at = year, labels = year)),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })
detach(totals)
dev.off()

rm(vehiclescc, totals)
