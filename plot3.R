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

library(dplyr)

# aggregate emission by year
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

#
# Plot
#

library(ggplot2)

png(filename = "plot3.png", width = 640, height = 480, units = "px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous(name = "Year of Emissions", breaks = totals$year) +
    labs(color = "Emission Source Type") +
    labs(y = "Total Emissions (tons)") +
    ggtitle(expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions by Source Type"))
dev.off()

#EOF
