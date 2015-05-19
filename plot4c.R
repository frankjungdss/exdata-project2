#!/usr/bin/R --verbose --quiet

# PLOT 4c

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
# So need to get all SCC codes that fall into these EI sectors.

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Coal)(?=.*Comb)", scc$EI.Sector, perl = T), "SCC"])

# by year and source type, calculate the coeffcient of variation (mean / std)
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = mean(Emissions)/sd(Emissions))

# report use lowercase type for legend
totals <- transform(totals, type = factor(tolower(type)))

# plot variability by year
png(filename = "plot4c.png", width = 640)
totals %>%
    ggplot(aes(year, total, group = type, colour = type)) +
    geom_point(aes(shape = type), size = 4) +
    geom_line() +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = totals$year) +
    scale_y_continuous(name = "Emissions CV (mean/sd)", breaks = pretty_breaks(n = 10)) +
    labs(color = "Emission Source Type", shape = "Emission Source Type") +
    ggtitle(expression("United States: " * PM[2.5] * " Variation of Emissions from Coal Combustion Related Sources"))
dev.off()

rm(coalscc, totals)
