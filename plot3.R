#!/usr/bin/R --verbose --quiet

# PLOT 3

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable:
#
# (1) Which of these four sources have seen decreases in emissions from
#     1999–2008 for Baltimore City?
#
# (2) Which have seen increases in emissions from 1999–2008?*
#
# Baltimore City, Maryland: `fips` == "24510"

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")

#
# Summarise
#

# make sure we have packages installed to run analysis
if (!require("dplyr")) {
    stop("Required package dplyr missing")
}

# aggregate emission by year
library(dplyr)
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

#
# Plot
#

# make sure we have packages for plots
if (!require("ggplot2")) {
    stop("Required package ggplot2 missing")
}
library(ggplot2)

# plot total PM2.5 emissions by source type for Baltimore City, Maryland from years 1999 to 2008
png(filename = "plot3.png", width=640, height=480, units="px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous(name = "Year of Emissions", breaks = totals$year) +
    labs(color = "Emission Source Type") +
    labs(y = "Total Emissions (tons)") +
    ggtitle(expression(PM[2.5] * " Total emissions for Baltimore City, Maryland by source type"))
dev.off()

#EOF
