## This script will read in a dataset obtained from the National Emissions Inventory database
## and create a plot showing total emissions for the US from 1999 - 2008.

## The specific emissions data included in this plot is PM 2.5
## PM 2.5 refers to particulate matter 2.5 microns or less in width.
## Exposure to PM 2.5 can contribute to acute symptoms, such as eye, nose, and throat irritation, and 
## asthma, chronic respiratory disease, etc.

## This script is 1 / 6 completed for Course Project 2 in the Coursera course:
## Exploratory Data Analysis in R, through Johns Hopkins University
## Instructor: Roger Peng


## To Run
# setwd("ExData_Plotting2")
# source("plot1.R")




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




# Answer question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?

# To answer this question, we first need to sum PM2.5 emissions by year
Emissions.Totals <- aggregate(Emissions ~ year,NEI, sum)


# Now create a png for plot 1
png("plot1.png", width=680, height=680)


# Create a bar plot for plot 1 that shows total emissions by year

# Divide Emissions totals by 1 million to make plot easier to read
barplot(Emissions.Totals$Emissions/1000000,  
     
     # specify main title of bar plot
     main="PM 2.5 Emissions in the US: 1999 - 2008", 
     
     # specify x axis label
     xlab="Year",

     # specify x axis names
     names.arg=Emissions.Totals$year,
     
     # specify y label
     ylab = "PM 2.5 Emissions (millions of tons)", 
     
     # label orientation
     las=1,
     
     # specify color of histogram bars
     col="black",
     
     # specify relative size of main title text
     cex.main=1.25)


# End of Plot 1


# Turn plotting device off
dev.off()

# Plot 1 shows that PM 2.5 emissions have declined in the US between 1999 - 2008,
# from 7.3 million tons in 1999 to 3.5 million tons in 2008.
# However, the rate of decrease plateaued slightly between 2002 - 2005.

# The end

