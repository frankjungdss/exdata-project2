#!/usr/bin/R --verbose --quiet

# PLOT 5a

# How have emissions from motor vehicle sources changed from 1999–2008 in
# Baltimore City?
#
# Baltimore City, Maryland: `fips` == "24510"
#
# Include only mobile motor vehicle sources:
# vehiclescc <- scc[grepl("Mobile", scc$EI.Sector), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]

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

# points
png(filename = "plot5a.png", width = 640, height = 480, units = "px")
attach(totals)
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year of Emissions", breaks = year) +
    scale_y_continuous(name = "Total Emissions (tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("Baltimore City, Maryland:" * PM[2.5] * " Emissions from Motor Vehicle Sources"))
detach(totals)
dev.off()

rm(g, totals, vehiclescc)