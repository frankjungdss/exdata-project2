#!/usr/bin/R --verbose --quiet

# PLOT 5

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"
#
# Motor vehicle sources (EI.Sector) are:
# [1] Mobile - On-Road Gasoline Light Duty Vehicles
# [2] Mobile - On-Road Gasoline Heavy Duty Vehicles
# [3] Mobile - On-Road Diesel Light Duty Vehicles
# [4] Mobile - On-Road Diesel Heavy Duty Vehicles
#

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

#
# Summarise
#

vehiclescc <- scc[grep("mobile", scc$EI.Sector, ignore.case = T), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]

# make sure we have packages installed to run analysis
if (!require("dplyr")) {
    stop("Required package dplyr missing")
}

library(dplyr)

# get SCC (source code classification) digits for coal combustion related sources
#CHECK coal.scc <- scc[grep("coal", scc$EI.Sector, ignore.case = T), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]
coalscc <- data.frame(SCC = as.character(scc[grep("coal", scc$EI.Sector, ignore.case = T), "SCC"]))

# aggregate coal emissions by year
totals <- nei %>%
    filter(SCC %in% coalscc$SCC) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

# report total emissions in thousands of tons
totals$total <- totals$total / 10^3

#
# Plot
#

# make sure we have packages for plots
if (!require("ggplot2")) {
    stop("Required package ggplot2 missing")
}
library(ggplot2)
if (!require("scales")) {
    stop("Required package scales missing")
}
library(scales)

# plot emissions from motor vehicle sources changed from 1999 to 2008 in
# Baltimore City
png(filename = "plot5.png", width=640, height=480, units="px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous(name = "Year of Emissions", breaks = totals$year) +
    scale_y_continuous(name = "Total Emissions (thousands tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression(PM[2.5] * " United States emissions from coal combustion-related sources"))
dev.off()

#EOF
