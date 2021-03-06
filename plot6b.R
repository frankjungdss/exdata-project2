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
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# standardise emissions for each county
latotals <- nei %>%
    filter(fips == "06037") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))
latotals <- transform(latotals, total = (total - min(total))/(max(total) - min(total)))

bctotals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))
bctotals <- transform(bctotals,total = (total - min(total))/(max(total) - min(total)))

totals <- rbind(latotals, bctotals)
totals$fips <- factor(totals$fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland"))

png(filename = "plot6b.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, total, group = fips, color = fips)) +
    geom_point(aes(shape = fips), size = 3) +
    geom_smooth(method = "lm") +
    scale_color_brewer(palette = "Set1") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous("Year", breaks = totals$year) +
    scale_y_continuous("Relative Emissions (normalized)", breaks = pretty_breaks(n = 10)) +
    labs(color = "County", shape = "County") +
    ggtitle(expression(PM[2.5] * " Relative Emissions from Motor Vehicle Sources"))
dev.off()

rm(bctotals, latotals, totals, vehiclescc)
