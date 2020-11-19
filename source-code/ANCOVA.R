### ANCOVA example
# Analyze a factor while adjusting for a covariate, comparing energy expenditure of two castes of naked mole-rat while adjusting for differences in body mass using analysis of covariance ANCOVA.
# Read and inspect the data.

# Clean up the working environment
rm(list = ls())
# Verify working directory, should be ~/Documents/Analyses/lastname_first
getwd()
# install.packages("nlme")
library("nlme")
# Load tidyverse
library("tidyverse")

moleRat <- read_csv("datasets/abd/chapter18/chap18e4MoleRatLayabouts.csv")
head(moleRat)

# We are going to sort the data according to the value of the ln of body mass. This simplifies graphing of the model fits. The graph commands below assume that the data are sorted in this way.

moleRatSorted <- moleRat[ order(moleRat$lnMass), ]

# Scatter plot of the data.

plot(lnEnergy ~ lnMass, data = moleRat, type = "n", las = 1, bty = "l")
points(lnEnergy ~ lnMass, data = subset(moleRatSorted, caste == "worker"), 
       pch = 1, col = "firebrick")
points(lnEnergy ~ lnMass, data = subset(moleRatSorted, caste == "lazy"), 
       pch = 16, col = "firebrick")

# Fit models to the data, beginning with the model lacking an interaction term. Use lm because caste and mass are fixed effects. Save the predicted values in the data frame.

moleRatNoInteractModel <- lm(lnEnergy ~ lnMass + caste, data = moleRatSorted)
moleRatSorted$predictedNoInteract <- predict(moleRatNoInteractModel)

# Fit the full model, which includes the interaction term. Again, save the predicted values in the data frame.

moleRatFullModel <- lm(lnEnergy ~ lnMass * caste, data = moleRatSorted)
moleRatSorted$predictedInteract <- predict(moleRatFullModel)

# Visualize the model fits, beginning with the fit of the no-interaction model. Redraw the scatter plot (see commands above), if necessary, before issuing the following commands.

lines(predictedNoInteract ~ lnMass, data = subset(moleRatSorted, 
                                                  caste == "worker"), lwd = 1.5)
lines(predictedNoInteract ~ lnMass, data = subset(moleRatSorted, 
                                                  caste == "lazy"), lwd = 1.5)

# Visualize the fit of the full model, including the interaction term. Redraw the scatter plot, if necessary, before issuing the following commands.

lines(predictedInteract ~ lnMass, data = subset(moleRatSorted, 
                                                caste == "worker"), lwd = 1.5, lty = 2)
lines(predictedInteract ~ lnMass, data = subset(moleRatSorted, 
                                                caste == "lazy"), lwd = 1.5, lty = 2)

# Test the improvement in fit of the full model, including the interaction term. This is a test of the interaction term only.

anova(moleRatNoInteractModel, moleRatFullModel)

# Test for differences in ln body mass between castes, assuming that no interaction term is present in the mole rat population (i.e., assuming that the two castes hve equal slopes). Most commonly this is done using either "Type III" sums of squares (see footnote 5 on p 618 of the book) or "Type I" sums of squares (the default in R). The two methods do not give identical answers here because the design is not balanced (in a balanced design, each value of the x-variable would have the same number of y-observations from each group).
# Test using "Type III" sums of squares. We need to include a contrasts argument for the categorical variable in the lm command. Then we need to load the car package and use its Anova command. Note that "A" is in upper case in Anova().

moleRatNoInteractModelTypeIII <- lm(lnEnergy ~ lnMass + caste, data = moleRat, 
                                    contrasts = list(caste = contr.sum))
library(car)
Anova(moleRatNoInteractModelTypeIII, type = "III") # note "A" in Anova is capitalized

# Test using "Type I" (sequential) sums of squares. Make sure that the covariate (lnMass) comes before the factor (caste) in the lm formula, as shown. Note that "a" is in lower case in anova.

moleRatNoInteractModel <- lm(lnEnergy ~ lnMass + caste, data = moleRat)
anova(moleRatNoInteractModel)

# Residual plot from the linear model. 

plot( residuals(moleRatNoInteractModel) ~ fitted(moleRatNoInteractModel) )
abline(0,0)

# Normal quantile plot of residuals.

qqnorm(residuals(moleRatNoInteractModel), pch = 16, col = "firebrick", 
       las = 1, ylab = "Residuals", xlab = "Normal quantile", main = "")

