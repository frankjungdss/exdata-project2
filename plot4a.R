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
# http://stackoverflow.com/questions/24626280/plot-mean-and-standard-deviation-by-category-in-r

library(dplyr)
library(lattice)

nei <- readRDS("data/summarySCC_PM25.rds")
scc <- readRDS("data/Source_Classification_Code.rds")

# get SCC (source code classification) digits for coal combustion related sources
coalscc <- as.character(scc[grepl("(?=.*Coal)(?=.*Comb)", scc$EI.Sector, perl = T), "SCC"])

# get median emissions for each year by state (using median to reduce impact of outliers)
# only for state codes 01 ... 56, see http://www.epa.gov/envirofw/html/codes/state.html
# there are 53 in total as there are gaps in the 01 ... 56, no idea why ...
totals <- nei %>%
    filter(SCC %in% coalscc) %>%
    mutate(state = as.integer(substr(fips, 1, 2))) %>%
    filter(state < 57) %>%
    select(year, state, Emissions) %>%
    arrange(year, state) %>%
    group_by(year, state) %>%
    summarise(total = median(Emissions))
# normalise so we can compare relative changes between states
totals <- transform(totals,
                    year = factor(year, ordered = T),
                    state = factor(state, ordered = T),
                    total = (total - min(total))/(max(total) - min(total)))

# for each state plot year ~ normalised emissions
#
# so why has Indiana (18) emissions been rising?
# One reason given here http://www.sourcewatch.org/index.php/Mercury_and_coal
# Which reported: In Indiana, coal-burning power plants emit more mercury to the
# air each year than any other human activity.
# Source: Joseph Picard, "Mercury plagues Indiana", International Business Times, November 17, 2010.
png(filename = "plot4a.png", height = 720, width = 720, units = "px")
attach(totals)
xyplot(total ~ year | state,
       data = totals,
       as.table = TRUE,
       col = "blue",
       pch = 19,
       scales=list(x = list(rot=90)),
       xlab = "Year",
       ylab = "Emissions (normalised)",
       main = expression(PM[2.5] * " Relative Emissions from Coal Combustion Sources by State"),
       panel = function(x, y, ...) {
           panel.xyplot(x, y, cex = 0.8, ...)
           panel.lmline(x, y, col = "red")
       })
detach(totals)
dev.off()

rm(coalscc, totals)
