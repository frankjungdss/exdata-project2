#!/usr/bin/R --verbose --quiet

# PLOT 5

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
# 
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

# TODO:
# * get totals for BC and LA
# * create multi-plot

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

#
# Summarise
#

library(dplyr)

# get SCC (source code classification) digits for coal combustion related sources
vehiclescc <- as.character(scc[grep("Mobile", scc$EI.Sector), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

#
# Plot
#

library(ggplot2)
library(scales)

png(filename = "plot6.png", width = 640, height = 480, units = "px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_x_continuous(name = "Year of Emissions", breaks = totals$year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
dev.off()

#EOF
