---
output:
  html_document:
    fig_caption: yes
    keep_md: yes
    toc: yes
---

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

[source (plot1a.R)](plot1a.R)

### (b)
![PM[2.5] Emission totals for all sources](plot1b.png)

[source (plot1b.R)](plot1b.R)

Plot 2
======

*Have total emissions from PM2.5 decreased in the Baltimore City,
Maryland from 1999 to 2008?*

A linear regression model suggests that the total emissions in Baltimore City
have been decreasing from 1999 to 2008.

* Baltimore City, Maryland (`fips` == "24510")

### (a)
![PM[2.5] Emission totals for Baltimore City, Maryland](plot2a.png)

[source (plot2a.R)](plot2a.R)

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

[source (plot3a.R)](plot3a.R)

Plot 4
======

*Across the United States, how have emissions from coal combustion-related
sources changed from 1999–2008?*

Point emissions from coal combustion-related sources have decreased. Non-point
emissions from coal combustion-related sources have remained static.

### (a)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4a.png)

[source (plot4a.R)](plot4a.R)

### (b)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4b.png)

[source (plot4b.R)](plot4b.R)

### (c)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4c.png)

[source (plot4c.R)](plot4c.R)

### (d)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4d.png)

[source (plot4d.R)](plot4d.R)

### (e)
![PM[2.5] Emissions from coal combustion-related sources across United States](plot4e.png)

[source (plot4e.R)](plot4e.R)

Plot 5
======

*How have emissions from motor vehicle sources changed from 1999–2008 in
Baltimore City?*

There has been an overall reduction in motor vehicle emissions.

### (a)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot5a.png)

[source (plot5a.R)](plot5a.R)

### (b)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot5b.png)

[source (plot5b.R)](plot5b.R)

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

[source (plot6a.R)](plot6a.R)

### (b)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6b.png)

[source (plot6b.R)](plot6b.R)

### (c)
![PM[2.5] Emissions from motor vehicle sources in Baltimore City](plot6c.png)

[source (plot6c.R)](plot6c.R)

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
