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
# get some stats from nei
#
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

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(list(total = nei$Emissions), by = list(year = nei$year), sum)
png(filename = "plot1-1.png", width=480, height=480, units="px")
plot(totals$year, totals$total/10^6,
     xaxt = "n",
     xlab = "Year of Emissions",
     ylab="Total Emissions (millions tons)",
     main = expression(PM[2.5] * " Total Emissions for all Sources"))
axis(1, at = totals$year)
lines(lowess(totals$total/10^6 ~ totals$year), col=4, lwd=2)
dev.off()

library(dplyr)

totals <- nei %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))
# report total emissions in millions of tons
totals <- transform(totals, total = total / 10^6)

png(filename = "plot1-1.png", width=480, height=480, units="px")
x <- with(totals, barplot(total, width = 4, names.arg = year, las = 1, yaxs = "i"))
with(totals, text(x, total, labels = round(total, 2), pos = 1, offset = 0.5))
title(xlab = "Year of Emissions")
title(ylab = "Total Emissions (millions tons)")
title(main = expression(PM[2.5] * " Total Emissions for all Sources"))
dev.off()

rm(totals, x)

################################################################################
# PLOT 2
################################################################################

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(Emissions ~ year, data = subset(nei, fips == "24510"), sum)

png(filename = "plot2-1.png", width=480, height=480, units="px")
attach(totals)
lmfit <- lm(Emissions ~ year, totals)
plot(year, Emissions,
     xaxt = "n",
     xlab = "Year of Emissions",
     ylab="Total Emissions (tons)",
     main = expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions for all Sources"))
axis(1, at = year)
abline(lmfit, lty = 3, lwd = 2)
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

print("STILL TO DO")

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

# aggregate emissions by year
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

# report total emissions in thousands of tons, lowercase type for legend
totals <- transform(totals, total = total / 10^3, type = factor(tolower(type)))

# points
png(filename = "plot4-1.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    # geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year of Emissions", breaks = year) +
    scale_y_continuous(name = "Total Emissions (thousands tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
dev.off()

rm(coalscc, g, totals)

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

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for mobile sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, type = factor(tolower(type)))

# bar chart
png(filename = "plot5-1.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(x = year, y = total, fill = type))
g + geom_bar(stat = "identity", position = "stack") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_fill_brewer(palette = "Set1", name = "Emission Source Type") +
    scale_x_continuous(name = "Year of Emissions", breaks = year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n=10)) +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

# points
attach(totals)
png(filename = "plot5-2.png", width = 640, height = 480, units = "px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year of Emissions", breaks = year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
dev.off()
detach(totals)

rm(g, totals, vehiclescc)

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

library(dplyr)
library(lattice)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grep("Mobile", scc$EI.Sector), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions))

# need factors
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))
totals$type <- factor(tolower(totals$type))

png(filename = "plot6-1.png", width = 640, height = 480, units = "px")
attach(totals)
xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(4, 2),
       col = "blue",
       pch = 19,
       xlab = "Year of Emissions",
       ylab = "Total Emissions (tons)",
       main = expression(PM[2.5] * " Emissions from motor vehicle sources for selected locations"),
       scales = list(x = list(at = year, labels = year)),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })
detach(totals)
dev.off()

rm(totals, vehiclescc)