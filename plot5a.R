#!/usr/bin/R --verbose --quiet

# PLOT 5a

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for mobile sources
vehiclescc <- scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), c("SCC", "EI.Sector")]

# aggregate emissions by year by sector
totals <- nei %>%
    filter(fips == "24510") %>%
    inner_join(y = vehiclescc, by = "SCC") %>%
    mutate(sector = sub("Mobile - ", "", EI.Sector)) %>%
    select(year, sector, Emissions) %>%
    arrange(year, sector) %>%
    group_by(year, sector) %>%
    summarise(total = sum(Emissions))

# plot stacked bar graph for each year by emission sector
png(filename = "plot5a.png", width = 720, height = 640, units = "px")
totals %>%
    ggplot(aes(year, total, fill = sector)) +
    geom_bar(stat = "identity", position = "stack") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_fill_brewer("Emission Sector", palette = "Set1") +
    scale_x_continuous("Year", breaks = totals$year) +
    scale_y_continuous("Emissions (Tons)", breaks = pretty_breaks(n = 10)) +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
dev.off()

rm(totals, vehiclescc)
