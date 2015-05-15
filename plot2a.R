#!/usr/bin/R --verbose --quiet

# PLOT 2a

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(Emissions ~ year, data = subset(nei, fips == "24510"), sum)

png(filename = "plot2a.png", width = 480, height = 480, units = "px")
attach(totals)
plot(year, Emissions, xaxt = "n", xlab = "Year", ylab = "Total Emissions (tons)")
axis(1, at = year)
abline(lm(Emissions ~ year, totals), lty = 3, lwd = 2)
title(main = expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions for all Sources")
detach(totals)
dev.off()

rm(totals)
