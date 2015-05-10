CONTENTS
--------

Plot 1
------

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

The following plot shows the total PM2.5 emission from all sources for 
each of the years 1999, 2002, 2005, and 2008.


http://www.r-tutor.com/elementary-statistics/quantitative-data/cumulative-frequency-graph

We first find the frequency distribution of the eruption durations as follows. Check the previous tutorial on Frequency Distribution for details.

> duration = faithful$eruptions 
> breaks = seq(1.5, 5.5, by=0.5) 
> duration.cut = cut(duration, breaks, right=FALSE) 
> duration.freq = table(duration.cut)
We then compute its cumulative frequency with cumsum, add a starting zero element, and plot the graph.

> cumfreq0 = c(0, cumsum(duration.freq)) 
> plot(breaks, cumfreq0,            # plot the data 
+   main="Old Faithful Eruptions",  # main title 
+   xlab="Duration minutes",        # x−axis label 
+   ylab="Cumulative eruptions")   # y−axis label 
> lines(breaks, cumfreq0)           # join the points
