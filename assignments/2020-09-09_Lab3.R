### In class demonstration: Reading in and summarizing data
# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()

# At the beginning of a script, it is useful to make sure you have
# downloaded and installed all necessary packages
# install.packages("tidyverse") 
library("tidyverse")
# Check for updates
tidyverse_update()

# Reading in the Ward and Quinn data
ward_data <- read_csv("datasets/quinn/chpt3/ward.csv")

# Number of rows and columns
dim(ward_data)

# Summary statistics for full dataset together
summary(ward_data)

# Summary statistics by zone
ward_summ <- ward_data %>%
  group_by(ZONE) %>%
  summarise(mean_egg = mean(EGGS),
            sd_egg = sd(EGGS),
            median_egg = median(EGGS))

summ_eggs <- ward_data %>%
  group_by(ZONE) %>% 
  summarise(mean_eggs = mean(EGGS),
            median_eggs = median(EGGS),
            IQR_eggs = IQR(EGGS),
            sd_eggs = sd(EGGS),
            var_eggs = var(EGGS))  
silly <- read_csv("datasets/demos/silly_data.csv", 
                  col_types = cols(tidal_height = col_character(), 
                                   transect = col_character(), coqina = col_double()))
summ_silly <-silly %>%
  group_by(tidal_height) %>%
  summarise(mean_coqina = mean(coqina),
            median_coqina = median(coqina),
            IQR_coqina = IQR(coqina),
            sd_coqina = sd(coqina),
            var_coqina = var(coqina))

