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
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# scale emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))

totals <- transform(totals, fips = factor(fips, labels = c("Los Angeles County", "Baltimore City")))

png(filename = "plot6a.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, scale(total), group = fips, color = fips)) +
    geom_point(aes(color = fips, shape = fips), size = 3) +
    theme_light(base_family = "Avenir", base_size = 11) +
    geom_smooth(method = "lm", se = TRUE, aes(color = fips)) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = totals$year) +
    labs(y = "Relative Emissions (normalised)", color = "County", shape = "County") +
    ggtitle(expression(PM[2.5] * " Relative Emissions from Motor Vehicle Sources"))
dev.off()

rm(totals, vehiclescc)
