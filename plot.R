#!/usr/bin/R --verbose --quiet

#
# Clean workspace
#

rm(list=setdiff(ls(), c("nei", "scc")))
while(dev.cur() != 1) dev.off()
plot.new()

#
# Load data
#

scc <- readRDS("data/Source_Classification_Code.rds")
nei <- readRDS("data/summarySCC_PM25.rds")      # National Emissions Inventory

#
# EXPLORE
#

# get some stats from nei
names(nei) <- tolower(names(nei))

# TYPES

types <- factor(nei$type)

levels(types)
# [1] "NONPOINT" "NON-ROAD" "ON-ROAD"  "POINT"

summary(types)
# NONPOINT NON-ROAD  ON-ROAD    POINT
#   473759  2324262  3183599   516031

table(types)
# types
# NONPOINT NON-ROAD  ON-ROAD    POINT
#   473759  2324262  3183599   516031

plot(table(types))
plot(summary(types))


# FIPS

fips <- nei$fips
plot(table(fips))

# SCC

sccs <- factor(nei$scc)
summary(sccs)
plot(table(sccs))

# STATES
states <- substr(nei$fips,1, 2)

# EMISSIONS
emissions <- nei$emissions
summary(emissions)
plot(emmissions)


# EIS Sector
sectors <- scc$EI.Sector
mobile <- grep("Mobile", levels(sectors), value = T)
mobile <- grep("Mobile", levels(sectors), value = T)
mobile
#  [1] "Mobile - Aircraft"
#  [2] "Mobile - Commercial Marine Vessels"
#  [3] "Mobile - Locomotives"
#  [4] "Mobile - Non-Road Equipment - Diesel"
#  [5] "Mobile - Non-Road Equipment - Gasoline"
#  [6] "Mobile - Non-Road Equipment - Other"
#  [7] "Mobile - On-Road Diesel Heavy Duty Vehicles"
#  [8] "Mobile - On-Road Diesel Light Duty Vehicles"
#  [9] "Mobile - On-Road Gasoline Heavy Duty Vehicles"
# [10] "Mobile - On-Road Gasoline Light Duty Vehicles"


################################################################################
# PLOT 1
################################################################################

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.


################################################################################
# PLOT 2
################################################################################

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(Emissions ~ year, data = subset(nei, fips == "24510"), sum)
# report total emissions in millions of tons
totals <- transform(totals, total = total / 1000)
# totals <- nei[nei$fips == "24510", ]

png(filename = "plot2a.png", width = 480, height = 480, units = "px")
attach(totals)
boxplot(Emissions ~ year, totals, xaxt = "n", xlab = "Year", ylab = "Total Emissions (Tons x 1000)")
axis(1, at = year)
title(main = expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions from all Sources"))
detach(totals)
dev.off()

rm(totals)


################################################################################
# PLOT 3
################################################################################

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable:
#
# (1) Which of these four sources have seen decreases in emissions from
#     1999–2008 for Baltimore City?
#
# (2) Which have seen increases in emissions from 1999–2008?*
#
# Baltimore City, Maryland: `fips` == "24510"


################################################################################
# PLOT 4
################################################################################

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year)
totals <- transform(totals, year = factor(year))

#png(filename = "plot4e.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(x = year, y = Emissions))
g + geom_boxplot() +
    theme_light(base_family = "Avenir", base_size = 11) +
    ylab(label = "Emissions (Tons)") +
    xlab(label = "Year") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
#dev.off()

rm(g, coalscc, totals)


################################################################################
# PLOT 5
################################################################################

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"

# includes: Aircraft, Commercial Marine Vessels, Locomotives
# unique(scc[grepl("Mobile", scc$EI.Sector, fixed = T), "EI.Sector"])
# unique(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "EI.Sector"])


################################################################################
# PLOT 6
################################################################################

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")
