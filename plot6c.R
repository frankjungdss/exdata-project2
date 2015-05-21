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

# emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(fips, year, Emissions) %>%
    arrange(fips, year) %>%
    group_by(fips, year)
totals <- transform(totals,
                    year = factor(year),
                    fips = factor(fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland")))

# show variation of emissions over time
png(filename = "plot6c.png", width = 480, height = 480, units = "px")
attach(totals)
bwplot(log10(Emissions) ~ year | fips,
       data = totals,
       layout = c(1, 2),
       xlab = "Year",
       ylab = "Log10 Emissions (Tons)",
       main = expression(PM[2.5] * " Emissions from Motor Vehicle Sources"),
       panel = function(x, y, ...) {
           panel.bwplot(x, y, ...)
           panel.scales = list(x = list(at = year, labels = year))
       })
detach(totals)
dev.off()

rm(vehiclescc, totals)
