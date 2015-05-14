#!/usr/bin/R --verbose --quiet

# PLOT 4c

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# Sources of coal-combustion can be found in source code classification table (scc)
# Where coal-combustion sources can be drawn from:
#   unique(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "EI.Sector"])
#
# The unique coal combustion sources (EI.Sector) are:
# [1] "Fuel Comb - Electric Generation - Coal"
# [2] "Fuel Comb - Industrial Boilers, ICEs - Coal"
# [3] "Fuel Comb - Comm/Institutional - Coal"
#
# So need to get all SCC codes that fall into these EI sectors.
# http://stackoverflow.com/questions/24626280/plot-mean-and-standard-deviation-by-category-in-r

library(dplyr)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])

# mean emissions by year
# aggregate emission by year
totals <- nei %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(mean = mean(Emissions), sd = sd(Emissions))

png(filename = "plot4c.png", width = 640, height = 480, units = "px")
attach(totals)
par(mfrow = c(1, 2), mar = c(4, 5, 1, 1), oma = c(0, 0, 2, 0))
# means
plot(mean ~ year, totals,
     xaxt = "n", xlab = "Year of Emissions", ylab = "Mean Emissions (tons)")
axis(1, at = year)
abline(lm(mean ~ year, totals), lty = 3, lwd = 2)
# deviations from mean
plot(mean ~ year, totals,
     xaxt = "n", xlab = "Year of Emissions", ylab = "Deviation from Mean Emissions (tons)",
     ylim=c(min(mean - sd), max(mean + sd)))
lines(rbind(year, year, NA), rbind(mean - sd, mean + sd, NA))
axis(1, at = year)
title(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"), outer = TRUE)
detach(totals)
dev.off()

rm(coalscc, totals)
