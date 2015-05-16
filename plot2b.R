#!/usr/bin/R --verbose --quiet

# PLOT 2b

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- nei[nei$fips == "24510", c("Emissions", "year"]
totals <- transform(totals, year = factor(year))

png(filename = "plot2b.png", width = 480, height = 480, units = "px")
attach(totals)
boxplot(log(Emissions) ~ year, data = totals, xaxt = "n", xlab = "Year", ylab = "Log10 Emissions (tons)")
axis(1, at = year, labels = year)
title(main = expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions for all Sources"))
detach(totals)
dev.off()

rm(totals)
