#!/usr/bin/R --verbose --quiet

# PLOT 6b

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(mean = mean(Emissions), sd = sd(Emissions))
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))

# points
png(filename = "plot6b.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, mean)) +
    geom_point(size = 4) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = .2) +
    scale_x_continuous("Year", breaks = totals$year) +
    labs(y = "Mean Emissions (Tons)") +
    ggtitle(expression(PM[2.5] * " Mean Emissions from Motor Vehicle Sources selected locations")) +
    facet_grid(fips ~ ., scales = "free")
dev.off()

rm(totals, vehiclescc)
