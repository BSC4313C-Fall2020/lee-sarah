### Example of importing Project 1 data
# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()

# Load tidyverse
library("tidyverse")
# Check for updates
tidyverse_update()
clam <- read_csv("datasets/project1/clam.csv", 
                 col_types = cols(tidal_ht = col_factor(levels = c("low", 
                                                                   "med", "high"))))
