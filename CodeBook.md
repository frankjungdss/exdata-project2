---
title: "CodeBook"
author: "Frank Jung"
date: "20/05/2015"
output:
  html_document: default
  pdf_document:
    fig_height: 5
    fig_width: 7
    latex_engine: xelatex
---

# Introduction

Get information about the NEI from the [EPA National Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

The data for this project is available from the course web site as a single zip
file:

[Data Set](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip) [29Mb]

The zip file contains two files:

## PM2.5 Emissions Data 

File: `summarySCC_PM25.rds`

This file contains a data frame with all of the PM2.5 emissions data for 1999,
2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5
emitted from a specific type of source for the entire year. Here are the first
few rows.

```r
    fips      SCC Pollutant Emissions  type year
4  09001 10100401  PM25-PRI    15.714 POINT 1999
8  09001 10100404  PM25-PRI   234.178 POINT 1999
12 09001 10100501  PM25-PRI     0.128 POINT 1999
16 09001 10200401  PM25-PRI     2.036 POINT 1999
20 09001 10200504  PM25-PRI     0.388 POINT 1999
24 09001 10200602  PM25-PRI     1.490 POINT 1999
```

* `fips`: A five-digit number (represented as a string) indicating the U.S. county
* `SCC`: The name of the source as indicated by a digit string (see source code classification table)
* `Pollutant`: A string indicating the pollutant
* `Emissions`: Amount of PM2.5 emitted, in tons
* `type`: The type of source (point, non-point, on-road, or non-road)
* `year`: The year of emissions recorded

Load RDS data with

```r
nei <- readRDS("data/summarySCC_PM25.rds")
```

## Source Classification Code Table

File: `Source_Classification_Code.rds`

This table provides a mapping from the SCC digit strings in the Emissions table
to the actual name of the PM2.5 source. The sources are categorized in a few
different ways from more general to more specific and you may choose to explore
whatever categories you think are most useful. For example, source "10100101"
is known as "Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal".

Load RDS data with

```r
scc <- readRDS("data/Source_Classification_Code.rds")
```

# Notes

## EIS sectors

One particularly large change from the traditional labeling of sectors and
categories is for the EIS sectors "Mobile – Aircraft", "Mobile – Commercial
Marine Vessels", and "Mobile – Locomotives" that are included in EIS as part of
the point and nonpoint data categories4 rather than the nonroad category. 

NEI users who sum emissions by EIS data category rather than EIS sector should
be aware that these changes will give differences from historical summaries of
"nonpoint" and "nonroad" data unless care is taken to assign those emissions to
the historical grouping. 

Source: [2008_neiv3_tsd_draft.pdf](data/2008_neiv3_tsd_draft.pdf)

## Mobile sources overview

Mobile sources are sources of pollution caused by vehicles transporting goods or people (e.g., highway vehicles,
aircraft, rail, and marine vessels) and other nonroad engines and equipment, such as lawn and garden
equipment, construction equipment, engines used in recreational activities, and portable industrial, commercial,
and agricultural engines. 