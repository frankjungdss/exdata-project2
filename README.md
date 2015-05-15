---
output: html_document
---
CONTENTS
========

* [Plot 1][]
* [Plot 2][]
* [Plot 3][]
* [Plot 4][]
* [Plot 5][]
* [Plot 6][]
* [Resources][]

-----

Plot 1
======

*Have total emissions from PM2.5 decreased in the United States from 1999 to
2008?*

The following plot shows the total PM2.5 emission from all sources for each of
the years 1999, 2002, 2005, and 2008.

The plot below shows that the total emissions from PM2.5 have decreased in the
United States from 1999 to 2008.

### (a)
![PM[2.5] Emission totals for all sources](plot1a.png)

```r
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
x <- with(totals, barplot(total, width = 4, names.arg = year, las = 1, yaxs = "i"))
with(totals, text(x, total, labels = round(total, 2), pos = 1, offset = 0.5))
title(xlab = "Year")
title(ylab = "Total Emissions (millions tons)")
title(main = expression(PM[2.5] * " Total Emissions for all Sources"))
dev.off()

rm(totals)
```

### (b)
![PM[2.5] Emission totals for all sources](plot1b.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 1b

# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

nei <- readRDS("data/summarySCC_PM25.rds")

totals <- aggregate(list(total = nei$Emissions), by = list(year = nei$year), sum)

png(filename = "plot1b.png", width = 480, height = 480, units = "px")
plot(totals$year, totals$total/10^6,
     xaxt = "n",
     xlab = "Year",
     ylab = "Total Emissions (millions tons)")
axis(1, at = totals$year)
# lines(lowess(totals$total/10^6 ~ totals$year), col = 4, lwd = 2)
title(main = expression(PM[2.5] * " Total Emissions for all Sources"))
dev.off()

rm(totals)
```

Plot 2
======

*Have total emissions from PM2.5 decreased in the Baltimore City,
Maryland from 1999 to 2008?*

A linear regression model suggests that the total emissions in Baltimore City
have been decreasing from 1999 to 2008.

* Baltimore City, Maryland (`fips` == "24510")

### (a)
![PM[2.5] Emission totals for Baltimore City, Maryland](plot2a.png)

```r
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
```

Plot 3
======

*Of the four types of sources indicated by the type (point, nonpoint, onroad,
nonroad) variable, which of these four sources have seen decreases in emissions
from 1999–2008 for Baltimore City? Which have seen increases in emissions from
1999–2008?*

A linear regression model indicates that only the `point` source has
increased emissions over the years 1999 to 2008.

### (a)
![PM[2.5] Emission by source types for Baltimore City, Maryland](plot3a.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 3a

# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable:
#
# (1) Which of these four sources have seen decreases in emissions from
#     1999–2008 for Baltimore City?
#
# (2) Which have seen increases in emissions from 1999–2008?*
#
# Baltimore City, Maryland: `fips` == "24510"

library(dplyr)
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")

# aggregate emission by year
totals <- nei %>%
    filter(fips == "24510") %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

# for legend lowercase the emissions source types
totals <- transform(totals, type = factor(tolower(type)))

# points
png(filename = "plot3a.png", width = 640, height = 480, units = "px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type, shape = type), size = 3) +
    scale_shape_manual(values = c(15, 17, 18, 19)) +
    geom_smooth(method = "lm", se = FALSE, aes(color = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = totals$year) +
    labs(shape = "Emission Source Type", color = "Emission Source Type") +
    labs(y = "Total Emissions (tons)") +
    ggtitle(expression("Baltimore City, Maryland: " * PM[2.5] * " Total Emissions by Source Type"))
dev.off()

rm(totals, g)
```

Plot 4
======

*Across the United States, how have emissions from coal combustion-related
sources changed from 1999–2008?*

Point emissions from coal combustion-related sources have decreased. Non-point
emissions from coal combustion-related sources have remained static.

### (a)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4a.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 4a

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

# plot bar graph
png(filename = "plot4a.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total, fill = type))
g + geom_bar(stat = "identity", position = "stack") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_fill_brewer(name = "Emission Source Type", palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = year) +
    scale_y_continuous(name = "Total Emissions (thousands tons)", breaks = pretty_breaks(n = 10)) +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
dev.off()

rm(coalscc, g, totals)
```

### (b)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4b.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 4b

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
totals <- transform(totals, total = total / 1000, type = factor(tolower(type)))

# plot points
png(filename = "plot4b.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    # geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = year) +
    scale_y_continuous(name = "Total Emissions (thousands tons)", breaks = pretty_breaks(n = 10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
dev.off()

rm(coalscc, g, totals)
```

### (c)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4c.png)

```r
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
    filter(SCC %in% coalscc) %>%
    select(year, Emissions) %>%
    arrange(year) %>%
    group_by(year) %>%
    summarise(mean = mean(Emissions), sd = sd(Emissions))

# multi-plot
png(filename = "plot4c.png", width = 640, height = 480, units = "px")
attach(totals)
par(mfrow = c(1, 2), mar = c(4, 5, 1, 1), oma = c(0, 0, 2, 0))
# plot means
plot(mean ~ year, totals,
     xaxt = "n", xlab = "Year", ylab = "Mean Emissions (tons)")
axis(1, at = year)
abline(lm(mean ~ year, totals), lty = 3, lwd = 2)
# plot deviations from mean
plot(mean ~ year, totals,
     xaxt = "n", xlab = "Year",
     ylab = "Deviation from Mean Emissions (tons)", ylim = c(min(mean - sd), max(mean + sd)))
lines(rbind(year, year, NA), rbind(mean - sd, mean + sd, NA))
axis(1, at = year)
title(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"), outer = T)
detach(totals)
dev.off()

rm(coalscc, totals)
```

### (d)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4d.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 4d

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
# State Codes (first 2 digits of fips)
# http://www.epa.gov/envirofw/html/codes/state.html

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions for each year by state
# only for state codes 01 ... 56, see http://www.epa.gov/envirofw/html/codes/state.html
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.integer(substr(fips, 1, 2))) %>%
    filter(state < 56) %>%
    select(year, state, Emissions) %>%
    arrange(year, state) %>%
    group_by(year, state) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, state = factor(state), total = total / 10^3, year = factor(year))

png(filename = "plot4d.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(state, total))
g + geom_point(size = 3, aes(color = year, shape = year)) +
    # geom_smooth(method = lm, se = FALSE, aes(group = year, color = year)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    theme(axis.text.x = element_text(angle = 90)) +
    scale_shape_manual(values = c(15, 17, 18, 19)) +
    scale_color_brewer(palette = "Set1") +
    scale_x_discrete(name = "State Code (from fips)") +
    scale_y_continuous(name = "Emissions (thousands tons)", breaks = pretty_breaks(n = 10)) +
    labs(shape = "Year", color = "Year") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
detach(totals)
dev.off()

rm(g, coalscc, totals)
```

### (e)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4e.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 4e

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
# State Codes (first 2 digits of fips)
# http://www.epa.gov/envirofw/html/codes/state.html

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Comb)(?=.*Coal)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions for each year by state
# only for state codes 01 ... 56, see http://www.epa.gov/envirofw/html/codes/state.html
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.integer(substr(fips, 1, 2))) %>%
    filter(state < 56) %>%
    select(year, state, Emissions) %>%
    arrange(year, state) %>%
    group_by(year, state) %>%
    summarise(total = sum(Emissions))
totals <- transform(totals, state = factor(state), total = total / 1000, year = factor(year))

png(filename = "plot4e.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(x = total))
g + geom_density(aes(group = year, color = year), size = 1) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    xlab(label = "By State Emission (thousands tons)") +
    scale_y_continuous(name = "Emission Relative Density") +
    labs(color = "Year") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions Density from Coal Combustion Related Sources by State"))
detach(totals)
dev.off()

rm(g, coalscc, totals)
```

Plot 5
======

*How have emissions from motor vehicle sources changed from 1999–2008 in
Baltimore City?*

There has been an overall reduction in motor vehicle emissions.

### (a)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot5a.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 5a

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"

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

# plot points
png(filename = "plot5a.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 3) +
    theme_light(base_family = "Avenir", base_size = 11) +
    geom_smooth(method = "lm", se = FALSE, aes(color = type)) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n = 10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

rm(g, totals, vehiclescc)
```

### (b)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot5b.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 5b

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"

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

# plot bar graph
png(filename = "plot5b.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total, fill = type))
g + geom_bar(stat = "identity", position = "stack") +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_fill_brewer(name = "Emission Source Type", palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n = 10)) +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

rm(g, totals, vehiclescc)
```

Plot 6
======

*Compare emissions from motor vehicle sources in Baltimore City with emissions
from motor vehicle sources in Los Angeles County, California. Which city has
seen greater changes over time in motor vehicle emissions?*

* Baltimore City, Maryland (`fips` == "24510")
* Los Angeles County, California (`fips` == "06037")

Los Angeles County has seen seen the greatest fluctuation in emissions.

### (a)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6a.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 6a

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
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, type, Emissions) %>%
    arrange(year, fips, type) %>%
    group_by(year, fips, type) %>%
    summarise(total = sum(Emissions), types = n())
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))
totals$type <- factor(tolower(totals$type))

# lattice
png(filename = "plot6a.png", width = 640, height = 480, units = "px")
attach(totals)
xyplot(total ~ year | type + fips,
       data = totals,
       layout = c(3, 2),
       col = "blue",
       pch = 19,
       xlab = "Year",
       ylab = "Total Emissions (tons)",
       main = expression(PM[2.5] * " Emissions from motor vehicle sources for selected locations"),
       scales = list(x = list(at = year, labels = year)),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, ...)
           panel.lmline(x, y, col = 2)
       })
detach(totals)
dev.off()

rm(vehiclescc, totals)
```

### (b)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6b.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 6b

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# aggregate emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(mean = mean(Emissions), sd = sd(Emissions))
totals$fips <- factor(totals$fips, labels = c("Los Angeles County", "Baltimore City"))

# points
png(filename = "plot6b.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(totals, aes(x = year, y = mean)) +
    geom_errorbar(aes(ymin = mean - sd, ymax = mean + sd), width = .2) +
    # geom_smooth(method = lm, se = FALSE) +
    geom_point(size = 4) +
    scale_x_continuous(name = "Year", breaks = totals$year) +
    labs(y = "Mean Emissions (tons)") +
    ggtitle(expression(PM[2.5] * " Mean Emissions from Motor Vehicle Sources selected locations"))
g + facet_grid(fips ~ ., scales = "free")
detach(totals)
dev.off()

rm(g, totals, vehiclescc)
```

### (c)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6c.png)

```r
#!/usr/bin/R --verbose --quiet

# PLOT 6c

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)
library(ggplot2)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# scale emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(year, fips, Emissions) %>%
    arrange(year, fips) %>%
    group_by(year, fips) %>%
    summarise(total = sum(Emissions))

totals <- transform(totals, scale = scale(total),
                    fips = factor(fips, labels = c("Los Angeles County", "Baltimore City")))

png(filename = "plot6c.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, scale))
g + geom_point(aes(color = fips), size = 3) +
    theme_light(base_family = "Avenir", base_size = 11) +
    geom_smooth(method = "lm", se = TRUE, aes(color = fips)) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year", breaks = year) +
    labs(y = "Total Emissions (normalised)") +
    ggtitle(expression(PM[2.5] * " Scaled Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

rm(g, totals, vehiclescc)
```

Resources
=========

* [EPA Emission Basics](http://www.epa.gov/air/emissions/basic.htm)
* [EPA FIPS State Codes](http://www.epa.gov/envirofw/html/codes/state.html)
* [ggplot2 Bar and line graphs](http://www.cookbook-r.com/Graphs/Bar_and_line_graphs_(ggplot2)/)
* [Project Data Set](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) [29Mb]
* [EPA Inventory Data](http://www.epa.gov/ttn/chief/net/2002inventory.html#inventorydata)
* [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html)
* [Plot hints](https://www.stat.auckland.ac.nz/~paul/RGraphics/chapter3.html)
* [An easy way to start using R in your research exploratory data analysis](http://bitesizebio.com/19666/an-easy-way-to-start-using-r-in-your-research-exploratory-data-analysis/)
