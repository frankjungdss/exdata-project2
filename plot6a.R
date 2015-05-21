#!/usr/bin/R --verbose --quiet

# PLOT 6a

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(fips, Emissions) %>%
    arrange(fips) %>%
    group_by(fips)
totals <- transform(totals, fips = factor(fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland")))

png(filename = "plot6a.png", width = 640, height = 480, units = "px")
attach(totals)
boxplot(log10(Emissions) ~ fips, data = totals, names.arg = fips)
title(ylab = "log10 Emissions (Tons)")
title(main = expression(PM[2.5] * " Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

rm(totals, vehiclescc)
