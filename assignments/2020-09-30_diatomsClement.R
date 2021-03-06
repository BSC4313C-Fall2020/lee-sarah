# Medley and Clements diatom data ANOVA
#### Lab 7: 1-way ANOVA #### 
# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()

# Install package ggfortify, *note* only do install.packages ONCE
# ggfortify is a package that works with ggplot2 to make nice plots
# install.packages("ggfortify")
library("ggfortify")
# multcomp is used for contrasts and multiple comparisons
# install.packages("multcomp")
library("multcomp")
# nlme is used for random effects ANOVA
# install.packages("nlme")
library("nlme")

# Load tidyverse
library("tidyverse")
# Check for updates
tidyverse_update()

### General workflow ####

# The general workflow as you do analyses in R should be as follows:
#   Step 1.  Plot your data (boxplots, histograms, Q-Q plots)
#   Step 2.  Use the function lm() to fit a model, specifying equation & data
#     e.g., y ~ x, data = data
#   Step 3.  Check assumptions again, using residuals plot
#   Step 4.  If assumptions are met, use the functions anova() and summary() 
#     to interpret statistical results.  If assumptions are not met, try 
#     data transformation and/or a non-parametric or robust version of the test

### Fixed effects ANOVA ####

### Step 1.  Read in and plot data ####

# I have added a new folder with datafiles located at "datasets/r4all"
# diatom <-read_csv("datasets/r4all/diatomgrowth.csv", col_types = cols(
#   ZINC = col_factor() ))

diatom <- read_csv("datasets/quinn/chpt8/medley.csv", col_types = cols(ZINC = col_factor(levels = c("BACK", "LOW", "MED", "HIGH")), ZNGROUP = col_character()))

# It is important to read in the predictor as a factor
# In the case of this dataset, the ZINC names have a space so I recoded
# the factor levels using the function fct_recode()
# The Shannon-Weiner diversity is coded as DIVERSTY which is misspelled, so correct it here.
diatom <- diatom %>%
  mutate(DIVERSITY = DIVERSTY)

# The research question here is two-fold: Q1: whether ZINCs alter host growth rates, 
# Q2: whether each of the three ZINCs reduces growth, compared with a BACK, 
# no parsite treatment.  The host is diatom, genus of water flea.

# Look at the data
head(diatom)
summary(diatom)

# When you do a normal boxplot, the ZINC species names overlap and are illegible
# so add a line that tells ggplot to flip the x and y axes, coord_flip()
ggplot(diatom, aes(x = ZINC, y = DIVERSITY))+
  geom_boxplot() +
  theme_bw()
 
ggplot(diatom) +
  geom_histogram(aes(DIVERSITY), binwidth = 0.4)+
  facet_wrap(~ZINC)
ggplot(diatom)+
  geom_qq(aes(sample = DIVERSITY, color = ZINC))

### Step 2.  Construct your ANOVA ####

# Similar to our two-sample t-test, you specify an equation (y~x) and the data

model01 <- lm(DIVERSITY~ZINC, data = diatom)

# You will see the model01 object in your Environment tab.  If you click on the 
# blue triangle, you will see all the bits and pieces generated by the function
# lm()

### Step 3.  Check the assumptions, again ####

# You alread have a good idea about normality, based on the preliminary plots in 
# Step 1.  After the model is fitted we can check the residuals too.
# I prefer to compare the ratio of standard deviations at this point in my code,
# but you could have done it earlier if you please.

summ_DIVERSITY <- diatom %>%
  group_by(ZINC) %>% 
  summarise(mean_DIVERSITY = mean(DIVERSITY),
            sd_DIVERSITY = sd(DIVERSITY),
            n_DIVERSITY = n())
ratio <-(max(summ_DIVERSITY$sd_DIVERSITY))/(min(summ_DIVERSITY$sd_DIVERSITY))

# The function autoplot will give you a residuals by predicte plot, which is 
# called "Residuals vs. Fitted" here.  It also gives you a Q-Q plot of the RESIDUALS.

autoplot(model01)

# If it looks hideous, try clicking on the little Zoom magnifying glass to open
# the plot in a larger window.

### Step 4. Interpret results ####

# Use the function anova() to answer our first research question: is there an effect
# of ZINC treatment on diatom growth rate?

anova(model01)

# the row beginning with our predictor variable name (ZINC) shows a significant
# p<0.0001, so there is an effect of ZINC treatment on growth rate.

# To address the second question, which ZINCs are different from the BACK, we
# can choose among approaches.

# Start with a summary of the model results
summary(model01)

# There are 4 rows in the table of coefficients and the first row is labeled intercept.
# Do not be fooled!  This is not the grand mean as a reasonable human might expect!
# Instead, because R alphabetized the names of your ZINC treatment groups, it 
# is the mean of the BACK (C comes before M and P in the alphabet) group. 
# So going forward, just assume that the word '(Intercept)' represents the first 
# level of the alphabetically ordered treatment levels.  Treatment contrasts
# report differences between the reference level (in this lucky case the BACK)
# and the other levels.  So in the summary table the numbers associated with each
# ZINC are differences between growth rates associated with that ZINC and
# the BACK.

# Because the BACK ended up as the reference group, the p-values associated 
# with the contrasts are actually useful.  That said, they are totally at risk
# of elevated type I error, so you'd be better off using Tukey HSD to evaluate 
# pairwise differences!

### Multiple Comparisons ####

# Earlier you installed and loaded the package multcomp.  To do planned comparisons
# we will use a function in multcomp called glht, short for general linear
# hypotheses.
# linfct specifies the linear hypotheses to be tested, I find the easiest way
# is to specify by name

# Planned comparisons

planned <- glht(model01, linfct = 
                  mcp(ZINC = c("LOW - BACK = 0",
                                   "MED - BACK = 0",
                                   "HIGH - BACK = 0")))
confint(planned)
summary(planned)

# Unplanned comparisons
# The key things you need to specify here are the model name and the factor name

tukey <- glht(model01, linfct = mcp(ZINC = "Tukey"))
summary(tukey)

### Multiple Comparisons if package "multcomp" fails ####
model01_b <- aov(DIVERSITY ~ ZINC, diatom)
TukeyHSD(model01_b)


### Non-parametric Kruskal-Wallis test ####
# This is a very simple test output, it gives you a test statistic, df, and p

kruskal.test(DIVERSITY ~ ZINC, data = diatom)


### Robust Welch's ANOVA ####

# I cannot tell you why the function for this is called oneway.test()
# Regardless this is how you do it:
oneway.test(DIVERSITY ~ ZINC, data = diatom)

### Random effects ANOVA ####
# For this, we will use the example in your book examining the repeatibility of
# measurements on walking stick limbs
stick <- read_csv("datasets/abd/chapter15/chap15e6WalkingStickFemurs.csv",
                  col_types = cols(specimen = col_factor() ) )

# To include a random effect, we no longer use the linear model function lm(),
# instead we use lme()

# The random effects ANOVA function requires two formulas, rather than just one. 
# The first formula (beginning with "fixed =") is for the fixed effect. The walking
# stick insect example doesn't include a fixed-effect variable, so we just provide
# a symbol for a constant in the formula ("~ 1"), representing the grand mean. The
# second formula (beginning with "random =") is for the random effect. In this 
# example, the individual specimens are the random groups, and the second formula
# indicates this (the "~ 1" in the formula below indicates that each specimen has 
# its own mean). You will need to have loaded the nlme library.

model02 <- lme(fixed = femurLength ~ 1,
               random = ~1|specimen, data = stick)

# Obtain the variance components for the random effects using VarCorr. The output includes
# the standard deviation and variance for both components of random variation in the random
# effects model for this example. The first is the variance among the specimen means. This 
# is the variance among groups, and is confusingly labeled "Intercept" in the output. The
# second component is the variance among measurements made on the same individuals. This 
# is the within group variance, also known as the error mean square, and is labeled 
# "Residual" in the output.

model02_varcomp <- VarCorr(model02)
model02_varcomp

# This gives us the estimates of the variance components for groups/Intercept and 
# error/Residual

# To get repeatibility, tell R to do some math by extracting the first entry in the first
# column and calling it VarAmong

varAmong  <- as.numeric( model02_varcomp[1,1] )

# And then extracting the second entry in the first column and calling it VarWithin
varWithin <- as.numeric( model02_varcomp[2,1] )

# And then doing the math
repeatability <- varAmong / (varAmong + varWithin)
repeatability

# End of story, 74% of walking stick femur length is due to variability among actual
# insects, not picture analysis issues.








