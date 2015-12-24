## This script will read in a dataset obtained from the National Emissions Inventory database
## and create a plot showing coal combustion related emissions for the US from 1999 - 2008.

## The specific emissions data included in this plot is PM 2.5
## PM 2.5 refers to particulate matter 2.5 microns or less in width.
## Exposure to PM 2.5 can contribute to acute symptoms, such as eye, nose, and throat irritation, and 
## asthma, chronic respiratory disease, etc.

## This script is 4 / 6 completed for Course Project 2 in the Coursera course:
## Exploratory Data Analysis in R, through Johns Hopkins University
## Instructor: Roger Peng


## To Run
# setwd("ExData_Plotting2")
# source("plot4.R")


# Load libraries

library(plyr)  # need this library for join



# Read in data

# Data frame with all PM2.5 emissions data for 1999, 2002, 2005, and 2008.
# For each year the table contains number of tons of PM2.5 emitted from
# a specific type of source for the entire year
NEI <- readRDS("summarySCC_PM25.rds")


# Columns in NEI data frame:
# fips: A five digit number indicating US county
# SCC: The name of the source as indicated by a digit string
# Pollutant: A string indicating the pollutant
# Emissions: Amount of PM2.5 emitted, in tons
# type: The type of source (point, non-point, on-road, or non-road)
# year: The year of emissions recorded



# Data frame with the source classification codes for emissions sources.
# This data frame can be used to map the SCC digit strings in the emissions
# table to the actual name of the PM2.5 source.
SCC <- readRDS("Source_Classification_Code.rds")

# Columns in SCC data frame:


# Join SCC data to NEI data

NEI.w.SCC <- join(NEI, SCC, by = "SCC")




# Answer question 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

# To answer this question, we first need to subset our data to include only
# PM2.5 emissions from coal combustion-related sources

# In order to do this we must first identify combustion related sources, and 
# then identify which combustion related sources include coal combustion sources


# After inspecting the data it appears the simplest way to identify combustion sources 
# is to generate a logical vector identifying rows that contain "Comb"
# by using grepl to search for this phrase in the broadest SCC classification:
# SCC.Level.One
combustion.sources <- grepl("[Cc]omb", NEI.w.SCC$SCC.Level.One)

# Next, to identify any emissions source that uses coal,
# we will grepl the most specific SCC classification - SCC.Level.Four
coal.sources <- grepl("[Cc]oal", NEI.w.SCC$SCC.Level.Four)


# Now combine combustion sources and coal sources to identify coal combustion sources
coal.combustion <- (combustion.sources & coal.sources)


# Create a subset of NEI coal combustion sources
coal.subset <- NEI.w.SCC[coal.combustion,]


# Then sum PM2.5 emissions by year for the coal subset
Emissions.Totals.coal <- aggregate(Emissions ~ year,coal.subset, sum)


# Now create a png for plot 4
png("plot4.png", width=680, height=680)


# Create a bar plot for plot 4 that shows total emissions from coal combustion by year

# Divide emissions by 100 thousand to make plot easier to read
barplot(Emissions.Totals.coal$Emissions/100000,  
     
     # specify main title of histogram
     main="PM 2.5 Emissions from Coal Sources in the US: 1999 - 2008", 
     
     # specify x axis label
     xlab="Year",

     # specify x axis names
     names.arg=Emissions.Totals$year,
     
     # specify y label
     ylab = "PM 2.5 Emissions (hundreds of thousands of tons)", 
     
     # label orientation
     las=1,
     
     # specify color of histogram bars
     col="black",
     
     # specify relative size of main title text
     cex.main=1.25)



# End of Plot 4


# Turn plotting device off
dev.off()

# Plot 4 shows that PM 2.5 emissions from coal combustion-related sources have
# decreased across the US, from 5.5 hundred thousand tons in 1999 
# to 3.3 hundred thousand tons in 2008.
# However, even though PM 2.5 emissions from coal combustion-related sources did
# increase between 1999 - 2008, there was a slight uptick from 4.7 hundred thousand
# tons in 2002 to 4.8 hundred thousand tons in 2005.



# The end

