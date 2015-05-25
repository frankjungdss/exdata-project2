#!/usr/bin/R --verbose --quiet

# PLOT 6e

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
library(quantmod)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# standardise emissions for each county
totals <- nei %>%
    filter(fips %in% c("06037", "24510")) %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))

# calculate percentage change by county
totals$change = with(totals, ave(total, fips, FUN = Delt))
totals[is.na(totals$change),]$change <- 0

# factor for legend
totals$fips <- factor(totals$fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland"))

png(filename = "plot6e.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, change, group = fips, color = fips)) +
    geom_line(aes(color = fips)) +
    scale_color_brewer(palette = "Set1") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous("Year", breaks = totals$year) +
    scale_y_continuous("Relative Change in Emissions (%)", labels = percent_format(), breaks = pretty_breaks(20)) +
    labs(color = "County", shape = "County") +
    ggtitle(expression(PM[2.5] * " Percentage Change in Emissions from Motor Vehicle Sources"))
dev.off()

rm(totals, vehiclescc)
