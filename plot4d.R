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
# So need to get all SCC codes that fall into these EI sectors.

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), c("SCC", "EI.Sector")]

# aggregate emissions by year
totals <- nei %>%
    filter(SCC %in% coalscc$SCC) %>% # only coal scc for short inner join
    filter(as.integer(substr(fips, 1, 2)) < 57) %>% # only US states
    inner_join(y = coalscc, by = "SCC") %>% # will use ei.sector in chart
    mutate(sector = sub("Fuel Comb - ", "", EI.Sector)) %>%
    mutate(sector = sub(" - Coal", "", sector)) %>%
    select(year, sector, Emissions) %>%
    arrange(year, sector) %>%
    group_by(year, sector) %>%
    summarise(total = sum(Emissions))

# plot bar graph
# report total emissions in thousands of tons, lowercase type for legend
png(filename = "plot4d.png", width = 720)
totals %>%
    ggplot(aes(year, total/1000, fill = sector)) +
    geom_bar(stat = "identity", position = "stack") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_fill_brewer(name = "Emission Source Type", palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = totals$year) +
    scale_y_continuous(name = "Emissions (thousands Tons)", breaks = pretty_breaks(n = 10)) +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
dev.off()

rm(coalscc, totals)
