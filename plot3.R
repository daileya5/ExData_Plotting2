## This script will read in a dataset obtained from the National Emissions Inventory database
## and create a plot comparing different types of emissions, 
## e.g. point, non-point, on-road, non-road,
## for the Baltimore City from 1999 - 2008.

## The specific emissions data included in this plot is PM 2.5
## PM 2.5 refers to particulate matter 2.5 microns or less in width.
## Exposure to PM 2.5 can contribute to acute symptoms, such as eye, nose, and throat irritation, and 
## asthma, chronic respiratory disease, etc.

## This script is 3 / 6 completed for Course Project 2 in the Coursera course:
## Exploratory Data Analysis in R, through Johns Hopkins University
## Instructor: Roger Peng


## To Run
# setwd("ExData_Plotting2")
# source("plot3.R")


# Load libraries

library(plyr)  # need this library for join
library(ggplot2) # need this for plot


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



# Answer question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 


# To answer this question, we first need to subset emissions data
# for Baltimore City, Maryland
NEI.w.SCC.Baltimore.City <- NEI.w.SCC[which(NEI.w.SCC$fips == "24510"),]


# Then ggplot does the rest!




# creates facets of bar plots for each type of PM2.5 emissions source
# Use years as character to force discrete values on the X axis
# Use emissions (divided by 1 thousand to make plots easier to read) on Y axis.
# Fill by type, to use different colors for each type of source of PM2.5 emissions.

plot3 <- ggplot(NEI.w.SCC.Baltimore.City, aes(as.character(year), Emissions/1000, fill = type)) + 

	# Use theme_bw() to use black lines on white background, instead of default gray background
	theme_bw() +

	# Add the bar chart geometry to the plot
	geom_bar(stat = "identity") +

	# Use the color brewer qualitative palette to color the bars in the bar plot
	scale_fill_brewer(type = "qual", palette = 6) +

	# Create a facet plot for each type of PM2.5 emissions source
	facet_wrap(~ type) + 

	# Define the title of the main plot
	ggtitle ("PM 2.5 Emissions by Type for Baltimore City:\n 1999 - 2008") + 

	# Define the label on the Y axis
	ylab("PM 2.5 Emissions (thousands of tons)") + 

	# Define the label on the X axis
	xlab("Year") +


	# Format the text for the X axis title
	theme(axis.title.x = element_text(face="bold", size = 10, vjust = -0.5), 

	# Format the text for the Y axis title
	axis.title.y = element_text(face="bold", size = 10), 

	# Format the text for the Main plot title
	plot.title= element_text(face="bold", size=14, vjust = 2), 

	# Format the text for the labels on the X and Y axes
	axis.text = element_text(face="plain", size=10),

	# Format the text on the facet titles
	strip.text.x = element_text(face="bold", size = 10),

	# Suppress the legend
	legend.position="non")


# Print plot 3
plot3 

ggsave("plot3.png", width = 5, height = 6.5, dpi=150)

# End of Plot 3




# Plot 3 shows that PM 2.5 emissions have:

# decreased from 1999 - 2008 for non-road, on-road, and nonpoint emissions sources.
# However, for all three of these sources, PM2.5 emissions declined the most between 1999 - 2002,
# remained at about the same values between 2002 - 2005, and
# decreased moderately between 2005 - 2008, relative to the much larger decrease between 1999 - 2002.

# increased from 1999 - 2005 followed by a decrease between 2005 - 2008 for point source polutions.
# PM2.5 emissions from point sources approximately doubled between 1999 and 2002, then doubled again between 2002 and 2005, then decreased substantially to return to 1999 levels by 2008.




# The end