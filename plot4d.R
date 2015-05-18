#!/usr/bin/R --verbose --quiet

# PLOT 4d

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# Sources of coal-combustion can be found in source code classification table (scc)
# Where coal-combustion sources can be drawn from:
#   unique(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "EI.Sector"])
#
# The unique coal combustion sources (EI.Sector) are:
# [1] "Fuel Comb - Electric Generation - Coal"
# [2] "Fuel Comb - Industrial Boilers, ICEs - Coal"
# [3] "Fuel Comb - Comm/Institutional - Coal"
#
# State Codes (first 2 digits of fips)
# http://www.epa.gov/envirofw/html/codes/state.html

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Coal)(?=.*Comb)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions for each year by state
# only for state codes 01 ... 56, see http://www.epa.gov/envirofw/html/codes/state.html
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.integer(substr(fips, 1, 2))) %>%
    filter(state < 56) %>%
    select(year, state, Emissions) %>%
    arrange(year, state) %>%
    group_by(year, state) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, state = factor(state), total = total / 10^3, year = factor(year))

png(filename = "plot4d.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(state, total, group = year, color = year))
g + geom_point(size = 3, aes(shape = year)) +
    geom_line() +
    theme_light(base_family = "Avenir", base_size = 11) +
    theme(axis.text.x = element_text(angle = 90)) +
    scale_shape_manual(values = c(15, 17, 18, 19)) +
    scale_color_brewer(palette = "Set1") +
    scale_x_discrete(name = "State Code (from fips)") +
    scale_y_continuous(name = "Emissions (thousands tons)", breaks = pretty_breaks(n = 10)) +
    labs(shape = "Year", color = "Year") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
dev.off()

rm(g, coalscc, totals)
