## This script will read in a dataset obtained from the National Emissions Inventory database
## and create a plot showing motor vehicle emissions for Baltimore City from 1999 - 2008.

## The specific emissions data included in this plot is PM 2.5
## PM 2.5 refers to particulate matter 2.5 microns or less in width.
## Exposure to PM 2.5 can contribute to acute symptoms, such as eye, nose, and throat irritation, and 
## asthma, chronic respiratory disease, etc.

## This script is 5 / 6 completed for Course Project 2 in the Coursera course:
## Exploratory Data Analysis in R, through Johns Hopkins University
## Instructor: Roger Peng


## To Run
# setwd("ExData_Plotting2")
# source("plot5.R")


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




# Answer question 5
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

# Next, we need to subset the motor.vehicle.subset for Baltimore City, Maryland
motor.vehicle.subset.Baltimore.City <- motor.vehicle.subset[which(motor.vehicle.subset$fips == "24510"),]

# Then sum PM2.5 emissions by year for the motor vehicle subset
Emissions.Totals.motor.vehicles <- aggregate(Emissions ~ year,motor.vehicle.subset.Baltimore.City, sum)





# Create a bar plot for plot 5 that shows total emissions from motor vehicle sources by year

plot5 <- ggplot(Emissions.Totals.motor.vehicles, aes(as.character(year), Emissions)) + 

	# Use theme_bw() to use black lines on white background, instead of default gray background
	theme_bw() +

	# Add the bar chart geometry to the plot
	geom_bar(stat = "identity") +

	# Use the color brewer qualitative palette to color the bars in the bar plot
	#scale_fill_brewer(type = "qual", palette = 6) +

	# Create a facet plot for each type of PM2.5 emissions source
	#facet_wrap(~ type) + 

	# Define the title of the main plot
	ggtitle ("PM 2.5 Emissions from Motor Vehicles in\n Baltimore City: 1999 - 2008") + 

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
	#strip.text.x = element_text(face="bold", size = 10),

	# Suppress the legend
	legend.position="non")


# Print plot 5
plot5 

ggsave("plot5.png", width = 5, height = 6.5, dpi=150)

# End of Plot 5



# Plot 5 shows that PM 2.5 emissions from motor vehicle sources in Baltimore City have
# decreased from 346 tons in 1999 to 88 tons in 2008.
# The largest decrease in PM 2.5 emissions was 212 tons, between 1999 and 2002, 
# followed by a decrease of 42 tons between 2005 and 2008.
# The smallest decrease was 3.9 tons between 2002 and 2008.



# The end

