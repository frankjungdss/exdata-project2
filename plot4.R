#!/usr/bin/R --verbose --quiet

# PLOT 4

# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
#
# Sources of coal-combustion can be found in source code classification table (scc)
# Where coal-combustion sources can be drawn from:
#   coal <- grep("coal", scc$EI.Sector, ignore.case = T, value = T)
#
# The unique coal combustion sources (EI.Sector) are:
# [1] "Fuel Comb - Electric Generation - Coal"
# [2] "Fuel Comb - Industrial Boilers, ICEs - Coal"
# [3] "Fuel Comb - Comm/Institutional - Coal"
#
# So need to get all SCC codes that fall into these EI sectors.
#
# You can check this with:
#
# coalscc <- scc[grepl("coal", scc$EI.Sector, ignore.case = T) & grepl("comb", scc$EI.Sector, ignore.case = T), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]
# coalscc <- scc[grepl("coal", scc$EI.Sector, ignore.case = T), c("SCC", "Data.Category", "EI.Sector", "Short.Name")]
#
# But this is the same as just selecting on "coal" ..
# And is faster than doing this:
#
# coalscc <- scc %>% filter(grepl("Coal", EI.Sector)) %>% select(SCC)

#
# Load data
#

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

#
# Summarise
#

library(dplyr)

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("Coal", scc$EI.Sector), "SCC"])

# aggregate emissions by year
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    select(year, type, Emissions) %>%
    arrange(year, type) %>%
    group_by(year, type) %>%
    summarise(total = sum(Emissions))

# report total emissions in thousands of tons, lowercase type for legend
totals <- transform(totals, total = total / 10^3, type = factor(tolower(type)))

#
# Plot
#

library(ggplot2)
library(scales)

png(filename = "plot4.png", width = 640, height = 480, units = "px")
g <- ggplot(data = totals, aes(year, total))
g + geom_point(aes(color = type), size = 4) +
    geom_smooth(method = "lm", se = FALSE, aes(colour = type)) +
    theme_light(base_family = "Avenir", base_size = 11) +
    scale_color_brewer(palette = "Set1") +
    scale_x_continuous(name = "Year of Emissions", breaks = totals$year) +
    scale_y_continuous(name = "Total Emissions (thousands tons)", breaks = pretty_breaks(n=10)) +
    labs(color = "Emission Source Type") +
    ggtitle(expression("United States: " * PM[2.5] * " Emissions from Coal Combustion Related Sources"))
dev.off()

#EOF
