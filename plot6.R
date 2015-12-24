## This script will read in a dataset obtained from the National Emissions Inventory database
## and create a plot comparing motor vehicle emissions for Baltimore City compared to LA County from 1999 - 2008.

## The specific emissions data included in this plot is PM 2.5
## PM 2.5 refers to particulate matter 2.5 microns or less in width.
## Exposure to PM 2.5 can contribute to acute symptoms, such as eye, nose, and throat irritation, and 
## asthma, chronic respiratory disease, etc.

## This script is 6 / 6 completed for Course Project 2 in the Coursera course:
## Exploratory Data Analysis in R, through Johns Hopkins University
## Instructor: Roger Peng


## To Run
# setwd("ExData_Plotting2")
# source("plot6.R")


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




# Answer question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources inLos Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# To answer this question, we first need to subset our data to include only
# PM2.5 emissions from motor vehicle sources

# Before we can do this, we must first define a motor vehicle source, then
# decide how to identify it in the data.

# I am using this definition for motor vehicle:
# "A motor vehicle is a self-propelled road vehicle, commonly wheeled, that does not operate on rails."
# This definition includes only on-road (highway) vehicles, not off-road (off-highway) vehicles, farm equipment, etc.


# After inspecting the data it appears the simplest way to identify motor vehicles is to use
# SCC.Level.Two, because this column contains two categories that identify on-road vehicles:
# "Highway Vehicles - Diesel"
# "Highway Vehicles - Gasoline"


# So, based on the above definition, we will subset the full data set, based on records where:
# SCC.Level.Two = "Highway Vehicles - Diesel" or "Highway Vehicles - Gasoline"

motor.vehicle.subset <- NEI.w.SCC[ which(NEI.w.SCC$SCC.Level.Two =="Highway Vehicles - Diesel" | NEI.w.SCC$SCC.Level.Two =="Highway Vehicles - Gasoline"), ]

# Next, we need to subset the motor.vehicle.subset for Baltimore City, Maryland and LA County, CA
motor.vehicle.subset.BaltimoreC.LA <- motor.vehicle.subset[which(motor.vehicle.subset$fips == "24510" | motor.vehicle.subset$fips == "06037"),]


# Now add a column to the data frame that will be used to label the facets in plot 6
# We could label the facets with the fips column, but it would be nice to use more descriptive text

# This vector will be used to joining the facet names to the Baltimore / LA subset
fips <- c("24510","06037")

# This vector will be used to give descriptive names to the facet plots
facet.names <- c("Baltimore City", "Los Angeles County")

# combine the fips and facet.names vectors into one matrix
facet.labels <- cbind(fips, facet.names)

#convert the facet.labels matrix into a data frame
facet.labels <- as.data.frame(facet.labels)

# join the facet labels to the Baltimore City / LA County subset by the fips code
# use the result in the plot, and facet by facet.names
plot6.data <- join(motor.vehicle.subset.BaltimoreC.LA, facet.labels, by = "fips")






# Create a bar plot for plot 6 that shows total emissions from motor vehicle sources by year

plot6 <- ggplot(plot6.data, aes(as.character(year), Emissions, fill = facet.names)) + 

	# Use theme_bw() to use black lines on white background, instead of default gray background
	theme_bw() +

	# Add the bar chart geometry to the plot
	geom_bar(stat = "identity") +

	# Use the color brewer qualitative palette to color the bars in the bar plot
	scale_fill_brewer(type = "qual", palette = 6) +

	# Create a facet plot for each type of PM2.5 emissions source
	facet_wrap(~ facet.names) + 

	# Define the title of the main plot
	ggtitle ("PM 2.5 Emissions from Motor Vehicles 1999 - 2008 :\n Baltimore City vs. Los Angeles County") + 

	# Define the label on the Y axis
	ylab("PM 2.5 Emissions (tons)") + 

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


# Print plot 6
plot6 

ggsave("plot6.png", width = 6, height = 6.5, dpi=150)

# End of Plot 6




# Plot 6 shows that Los Angeles County has seen a greater change in PM 2.5 emissions from motor
# vehicles over 1999 - 2008. When compared with Baltimore City, Los Angeles County started 
# with significantly higher levels of PM 2.5 emissions from motor vehicles in 1999,
# nearly 4,000 tons for LA county vs about 350 tons for Baltimore City.
# PM 2.5 emissions in LA County increased to a maximum in 2005, before declining 
# to a level that was slightly higher than PM 2.5 emissions from motor vehicles in 1999.
# This compares to Baltimore City, which say a steady decline in PM 2.5 emissions from motor
# vehicles over the same time period.





# The end
