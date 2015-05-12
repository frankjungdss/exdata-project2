#!/usr/bin/R --verbose --quiet

# PLOT 2

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# from years 1999 to 2008?
#
# Baltimore City, Maryland: `fips` == "24510"

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")

#
# Summarise
#

library(dplyr)

# aggregate emission by year
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

# use linear regression model for trend analysis
lmfit <- lm(total ~ year, totals)

#
# Plot
#

png(filename = "plot2.png", width = 480, height = 480, units = "px")
with(totals, plot(year, total, xlab="", ylab="", xaxt = "n", pch = 19, col = "blue"))
with(totals, axis(1, at = year))
abline(lmfit, col = "red", lty = 3, lwd = 2)
title(xlab = "Year of Emissions")
title(ylab = "Total Emissions (tons)")
title(main = expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions for all Sources"))
dev.off()

#EOF
