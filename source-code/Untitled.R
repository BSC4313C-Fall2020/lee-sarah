#### In class example 2020-10-28 #####

# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()

# install.packages("nlme")
library("nlme")

# Load tidyverse
library("tidyverse")
# Check for updates
tidyverse_update()

### Read in data from Tomasko and Lapointe 1991 ####

# The datafile has combined Tables 1-3 and has NA for no observation
# Working with NAs requires constant vigilance and so for the purpose of this 
# exercise, I read in three versions of the datafile tomasko.csv

tomasko <- read_csv("datasets/example-analyses/tomasko.csv")

# data1 includes only the 0.5m data 
data1 <- tomasko %>%
  filter(depth == 0.5)

# data2 includes only the four sites with turnover data 
data2 <- tomasko %>%
  filter()





data3

