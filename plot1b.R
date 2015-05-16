#!/usr/bin/R --verbose --quiet

# PLOT 1b

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(list(total = nei$Emissions), by = list(year = nei$year), sum)

png(filename = "plot1b.png", width = 480, height = 480, units = "px")
plot(totals$year, totals$total/10^6, type = "b", xaxt = "n", xlab = "Year", ylab = "Emissions (millions Tons)")
axis(1, at = totals$year)
# lines(lowess(totals$total/10^6 ~ totals$year), col = 4, lwd = 2)
title(main = expression(PM[2.5] * " Emissions from all Sources"))
dev.off()

rm(totals)
