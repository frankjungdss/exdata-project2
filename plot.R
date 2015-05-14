#!/usr/bin/R --verbose --quiet

#
# Clean workspace
#

rm(list=setdiff(ls(), c("nei", "scc")))
while(dev.cur() != 1) dev.off()

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

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
