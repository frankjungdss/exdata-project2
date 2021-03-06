#!/usr/bin/R --verbose --quiet

# PLOT 5b

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
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# get median of emissions by year
totals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = median(Emissions))
totals <- transform(totals, type = factor(tolower(type)))

# show median emissions to show trend for mobile (road and non-road) sources
png(filename = "plot5b.png", width = 640, height = 480, units = "px")
totals %>%
    ggplot(aes(year, total, group = type, color = type)) +
    geom_point(aes(shape = type), size = 3) +
    geom_line() +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous("Year", breaks = totals$year) +
    scale_y_continuous("Median Emissions (Tons)", breaks = pretty_breaks(n = 10)) +
    labs(color = "Source Type", shape = "Source Type") +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
dev.off()

rm(totals, vehiclescc)
