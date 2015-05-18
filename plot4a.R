#!/usr/bin/R --verbose --quiet

# PLOT 4a

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

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Coal)(?=.*Comb)", scc$EI.Sector, perl = T), "SCC"])

# use color blind friendly palette,
# see http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/#a-colorblind-friendly-palette
cbp <- c("#000000", "#E69F00", "#56B4E9", "#009E73")

# aggregate emissions for each year by state
# only for state codes 01 ... 56, see http://www.epa.gov/envirofw/html/codes/state.html
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.integer(substr(fips, 1, 2))) %>%
    filter(state < 57) %>%
    select(year, state, Emissions) %>%
    arrange(year, state) %>%
    group_by(year, state) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, state = factor(state), year = factor(year))

# use density to show probability of a states emission total in Tons
# later years should show a higher likelihood of lower emissions
png(filename = "plot4a.png", width = 640)
totals %>%
    ggplot(aes(x = total/1000)) +
    geom_density(aes(group = year, color = year)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_colour_manual(values = cbp) +
    xlab(label = "State Emissions (thousands Tons)") +
    scale_y_continuous("State Emission Relative Density") +
    labs(color = "Year") +
    ggtitle(expression("United States: " * PM[2.5] * " State Emissions Density from Coal Combustion Related Sources"))
dev.off()

rm(cbp, coalscc, totals)
