#!/usr/bin/R --verbose --quiet

# PLOT 1a

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

library(dplyr)

nei <- readRDS("data/summarySCC_PM25.rds")

# aggregate emission by year
totals <- nei %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(total = sum(Emissions))

# report total emissions in millions of tons
totals <- transform(totals, total = total / 10^6)

# plot bar chart
png(filename = "plot1a.png", width = 480, height = 480, units = "px")
g <- with(totals, barplot(total, width = 4, names.arg = year, las = 1, yaxs = "i"))
with(totals, text(g, total, labels = round(total, 2), pos = 1, offset = 0.5))
title(xlab = "Year")
title(ylab = "Emissions (millions Tons)")
title(main = expression(PM[2.5] * " Emissions from all Sources"))
dev.off()

rm(g, totals)
