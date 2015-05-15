#!/usr/bin/R --verbose --quiet

# PLOT 5c

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds") # National Emissions Inventory
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for mobile sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# Use point source for SCC see http://www.epa.gov/ttn/chief/codes/index.html
# SCC has ~ 10,341 codes have either
# * point source = 8 digit code
# * area source = 10 digit code
# Source: http://www.epa.gov/ttn/chief/eidocs/basiceipreparationtraining_april2003.pdf

# aggregate emissions by year
totals <- nei %>%
    filter(fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, type = factor(tolower(type)))
totals <- transform(totals, year = factor(year))

# points
png(filename = "plot5c.png", width = 640, height = 480, units = "px")
attach(totals)

qplot(x = year, y = total, data = totals, color = type,
      xlab = "Source Classfication Code",
      ylab = "Total Emissions (tons)",
      main = (expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources")))

detach(totals)
dev.off()

rm(g, totals, vehiclescc)
