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

![PM[2.5] Emission totals for all sources](plot1.png)

![PM[2.5] Emission totals for all sources](plot1-1.png)

Plot 2
======

*Have total emissions from PM2.5 decreased in the Baltimore City,
Maryland from 1999 to 2008?*

A linear regression model suggests that the total emissions in Baltimore City
have been decreasing from 1999 to 2008.

* Baltimore City, Maryland (`fips` == "24510")

![PM[2.5] Emission totals for Baltimore City, Maryland](plot2.png)

Plot 3
======

*Of the four types of sources indicated by the type (point, nonpoint, onroad,
nonroad) variable, which of these four sources have seen decreases in emissions
from 1999–2008 for Baltimore City? Which have seen increases in emissions from
1999–2008?*

A linear regression model indicates that only the `point` source has
increased emissions over the years 1999 to 2008.

![PM[2.5] Emission by source types for Baltimore City, Maryland](plot3.png)

Plot 4
======

*Across the United States, how have emissions from coal combustion-related
sources changed from 1999–2008?*

Point emissions from coal combustion-related sources have decreased. Non-point
emissions from coal combustion-related sources have remained static.

![PM[2.5] Emissions from coal combustion-related sources across United States](plot4.png)

![PM[2.5] Emissions from coal combustion-related sources across United States](plot4-1.png)

Over reduction in mean of coal combustion-related emissions and less variation per year.

![PM[2.5] Emissions from coal combustion-related sources across United States](plot4-2.png)

Plot 5
======

*How have emissions from motor vehicle sources changed from 1999–2008 in
Baltimore City?*

There has been an overall reduction in motor vehicle emissions.

![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot5.png)

Plot 6
======

*Compare emissions from motor vehicle sources in Baltimore City with emissions
from motor vehicle sources in Los Angeles County, California. Which city has
seen greater changes over time in motor vehicle emissions?*

* Baltimore City, Maryland (`fips` == "24510")
* Los Angeles County, California (`fips` == "06037")

Los Angeles County has seen seen the greatest fluctuation in emissions.

![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6.png)

![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6-1.png)

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
