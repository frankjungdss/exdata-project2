#!/usr/bin/R --verbose --quiet

# PLOT 3a

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable:
#
# (1) Which of these four sources have seen decreases in emissions from
#     1999–2008 for Baltimore City?
#
# (2) Which have seen increases in emissions from 1999–2008?*
#
# Baltimore City, Maryland: `fips` == "24510"

library(dplyr)
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")

# aggregate emission by year
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

# for legend lowercase the emissions source types
totals <- transform(totals, type = factor(tolower(type)))

# plot summary totals for each year by source type
png(filename = "plot3a.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, total, group = type, color = type)) +
    geom_point(aes(shape = type), size = 3) +
    geom_line() +
    geom_smooth(method = "lm", linetype = 3, se = FALSE) +
    scale_color_brewer(palette = "Set1") +
    scale_shape_manual(values = c(15, 17, 18, 19)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous(breaks = totals$year) +
    labs(x = "Year") +
    labs(y = "Emissions (Tons)") +
    labs(shape = "Emission Source Type", color = "Emission Source Type") +
    ggtitle(expression("Baltimore City, Maryland: " * PM[2.5] * " Emissions by Source Type"))
dev.off()

rm(totals)
