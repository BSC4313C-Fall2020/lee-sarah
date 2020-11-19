# Example code for confidence intervals, without summarytools
# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()

# Load tidyverse
library(tidyverse)

### Confidence interval of the mean ###
### Confidence interval of the mean step by step ####
# To show an example of code for a confidence interval (similar to swirl bless its heart), I will use the
# calcium that was one of your in class problems.

coelomic <- tribble(
  ~calcium,
  28,
  27,
  29,
  29,
  30,
  30,
  31,
  30,
  33,
  27,
  30,
  32,
  31
)

# In swirl or certain problems, you will be given the mean, standard deviation and sample size.  Here I 
# calculate them directly and name them, mean <- mean(coelomic$calcium), but you can also just type in 
# the number, mean <- 29.76923.
data <- coelomic
summary <- coelomic %>%
  summarise(mean = mean(calcium),
            sd = sd(calcium),
            n = n())
          

alpha <- 0.05
mean <- summary$mean
se <- summary$sd/(sqrt(summary$n))
df <- summary$n -1
# In words, the confidence interval equation is 
# mean plus or minus the product of the critical value of t, given alpha and df, and the standard error of the mean.
# the mean you can calculate
# the "plus or minus" is accomplished with a short vector c(-1,-2) that you multiply by...
# the critical value of t using the function qt():  qt(1-alpha, df = n-1) which is also multiplied by...
# the standard error of the mean

# NOTE that in the swirl text it refers to the critical value of t as t_(n-1) which I think is bogus, but whatever.

# If you used summarise to calculate the descriptive statistics, then the code is
mean + c(-1,1)*qt(1-alpha, df )*se

