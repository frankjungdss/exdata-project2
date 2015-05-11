#!/usr/bin/R --verbose --quiet

# PLOT 4

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# Sources of coal-combustion can be found in source code classification table (scc)
# Where coal-combustion sources can be drawn from:
#   coal <- grep("coal", scc$EI.Sector, ignore.case = T, value = T)
#
# The unique coal combustion sources (EI.Sector) are:
# [1] "Fuel Comb - Electric Generation - Coal"
# [2] "Fuel Comb - Industrial Boilers, ICEs - Coal"
# [3] "Fuel Comb - Comm/Institutional - Coal"
# So need to get all SCC codes that fall into these EI sectors.
#
# You can check this with:
# coalscc <- scc[grep("coal", scc$EI.Sector, ignore.case = T), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

#
# Summarise
#

# make sure we have packages installed to run analysis
if (!require("dplyr")) {
    stop("Required package dplyr missing")
}

library(dplyr)

# get SCC (source code classification) digits for coal combustion related sources
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

# plot across the United States, how have emissions from coal combustion-related sources changed from years 1999 to 2008?
png(filename = "plot4.png", width=640, height=480, units="px")
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
