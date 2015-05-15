#!/usr/bin/R --verbose --quiet

#
# Clean workspace
#

rm(list=setdiff(ls(), c("nei", "scc")))
while(dev.cur() != 1) dev.off()

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

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.numeric(substr(fips, 1, 2))) %>%
    select(year, state, type, Emissions) %>%
    arrange(year, state, type) %>%
    group_by(year, state, type) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, type = factor(type), year = factor(year), state = factor(state))

# no negative values in data?!
nei[nei$Emissions < 0, ]
summary(nei$Emissions)

library(lattice)
attach(totals)

xyplot(total ~ state | year, data = totals,
       col = type, layout = c(4, 1), scales = list(x = list(rot = 90, cex = 0.8)))



barchart(total ~ state | year, data = totals,
         col = type,
         layout = c(1, 4),
         scales = list(x = list(rot = 90, cex = 0.8)))
# to add overall median line
         panel = function(x, y,...) {
             panel.barchart(x, y,...)
             panel.abline(h = median(total), col.line = "black", lty = 3)
         })

barchart(state ~ total | year, data = totals, col = type, layout = c(1, 4), horizontal = TRUE)
detach(totals)

library(lattice)
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])
coals <- nei[nei$SCC %in% coalscc, ]
coals <- transform(coals, SCC = factor(SCC), type = factor(type), year = factor(year))

summary(coals[coals$year == 1999 & coals$type == "NONPOINT", "Emissions"])
summary(coals[coals$year == 2002 & coals$type == "NONPOINT", "Emissions"])
summary(coals[coals$year == 2005 & coals$type == "NONPOINT", "Emissions"])
summary(coals[coals$year == 2008 & coals$type == "NONPOINT", "Emissions"])


#with(coals[coals$year == 1999, ], plot(SCC, Emissions, col = type))

attach(coals)
xyplot(Emissions ~ type | year, data = coals, col = type, layout = c(4, 1))

densityplot(type ~ Emissions | year, data = coals, main="Density Plot of Coal Emissions by Year", xlab="Emissions")
detach(totals)


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
totals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    mutate(points = substr(SCC, 1, 8)) %>%
    select(year, points, Emissions) %>%
    arrange(year, points) %>%
    group_by(year, points) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, points = factor(points))
# totals <- transform(totals, type = factor(tolower(type)))
totals <- transform(totals, year = factor(year))

# points
png(filename = "plot5c.png", width = 640, height = 480, units = "px")
attach(totals)

g <- qplot(x = points, y = total, data = totals, facets = year ~ .,
           xlab = "Source Classfication Code",
           ylab = "Total Emissions (tons)")
# labels <- seq(from = min(points), to = max(points), length.out = 10)

g + # scale_x_discrete(breaks = labels, labels = as.character(labels)) +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))

detach(totals)
dev.off()

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
