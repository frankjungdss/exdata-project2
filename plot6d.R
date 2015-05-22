#!/usr/bin/R --verbose --quiet

# PLOT 6d

# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California.
#
# Which city has seen greater changes over time in motor vehicle emissions?
#
# (a) Baltimore City, Maryland: `fips` == "24510"
# (b) Los Angeles County, California (fips == # "06037")

library(dplyr)
library(ggplot2)
library(scales)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for motor vehicle sources
vehiclescc <- as.character(scc[grepl("(?=.*Mobile - )(?=.*-Road)", scc$EI.Sector, perl = T), "SCC"])

# emissions by year by county and type
totals <- nei %>%
    filter(fips == "06037" | fips == "24510") %>%
    filter(SCC %in% vehiclescc) %>%
    select(fips, year, Emissions) %>%
    arrange(fips, year) %>%
    group_by(fips, year)
totals <- transform(totals,
                    total = log10(Emissions),
                    year = factor(year),
                    fips = factor(fips, labels = c("Los Angeles County, California", "Baltimore City, Maryland")))

# show variation of emissions over time
png(filename = "plot6d.png", width = 640, height = 720, units = "px")
totals %>%
    ggplot(aes(x = fips, y = total)) +
    geom_jitter(alpha = 0.75, aes(color = fips)) +
    geom_boxplot(alpha = 0.1, outlier.shape = NA) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_discrete("") +
    scale_y_continuous("Log10 Emissions (Tons)", breaks = pretty_breaks(n = 10)) +
    theme(legend.position="none") +
    facet_grid(year ~ .) +
    ggtitle(expression(PM[2.5] * " Relative Emissions from Motor Vehicle Sources"))
dev.off()

rm(vehiclescc, totals)
