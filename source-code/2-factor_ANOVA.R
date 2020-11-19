### Two-factor ANOVA example

# Example 18.3 <a href="../wp-content/data/chapter18/chap18e3IntertidalAlgae.csv">Intertidal interaction zone
# Analyze data from a factorial experiment investigating the effects of herbivore presence, height above low tide, and the interaction between these factors, on abundance of a red intertidal alga using two-factor ANOVA.
# Read and inspect the data.

algae <- read.csv(url("http://www.zoology.ubc.ca/~schluter/WhitlockSchluter/wp-content/data/chapter18/chap18e3IntertidalAlgae.csv"))
head(algae)

# Fit the null model having both main effects but no interaction term. Note that we use lm because both factors are fixed effects.

algaeNoInteractModel <- lm(sqrtArea ~ height + herbivores, data = algae)

# Fit the full model, with interaction term included.

algaeFullModel <- lm(sqrtArea ~ height * herbivores, data = algae)

# Visualize the model fits, beginning with the no-interaction model.

interaction.plot(algae$herbivores, algae$height, response = predict(algaeNoInteractModel), 
                 ylim = range(algae$sqrtArea), trace.label = "Height", las = 1,
                 ylab = "Square root surface area (cm)", xlab = "Herbivore treatment")
adjustAmount = 0.05
points(sqrtArea ~ c(jitter(as.numeric(herbivores), factor = 0.2) + adjustAmount), 
       data = subset(algae, height == "low"))
points(sqrtArea ~ c(jitter(as.numeric(herbivores), factor = 0.2) - adjustAmount), 
       data = subset(algae, height == "mid"), pch = 16)

# Visualize the model fits, continuing with the full model including the interaction term.

interaction.plot(algae$herbivores, algae$height, response = predict(algaeFullModel), 
                 ylim = range(algae$sqrtArea), trace.label = "Height", las = 1,
                 ylab = "Square root surface area (cm)", xlab = "Herbivore treatment")
adjustAmount = 0.05
points(sqrtArea ~ c(jitter(as.numeric(herbivores), factor = 0.2) + adjustAmount), 
       data = subset(algae, height == "low"))
points(sqrtArea ~ c(jitter(as.numeric(herbivores), factor = 0.2) - adjustAmount), 
       data = subset(algae, height == "mid"), pch = 16)

# 	
# Test the improvement in fit of the model including the interaction term. 

anova(algaeNoInteractModel, algaeFullModel)

# Test all terms in the model in a single ANOVA table. Most commonly, this is done using either "Type III" sums of squares (see footnote 5 on p 618 of the book) or "Type I" sums of squares (which is the default in R). In the present example the two methods give the same answer, because the design is completely balanced, but this will not generally happen when the design is not balanced.
# Here is how to test all model terms using "Type III" sums of squares. We need to include a contrasts argument for the two categorical variables in the lm command. Then we need to load the car package and use its Anova command. Note that "A" is in upper case in Anova - a very subtle difference.

algaeFullModelTypeIII <- lm(sqrtArea ~ height * herbivores, data = algae, 
                            contrasts = list(height = contr.sum, herbivores = contr.sum))
library(car)
Anova(algaeFullModelTypeIII, type = "III") # note "A" in Anova is capitalized

# Here is how we test all model terms using "Type I" (sequential) sums of squares. Note that "a" is in lower case in anova.

anova(algaeFullModel)

# A residual plot from the full model.

plot( residuals(algaeFullModel) ~ fitted(algaeFullModel) )
abline(0,0)

# A normal quantile plot of the residuals.

qqnorm(residuals(algaeNoInteractModel), pch = 16, col = "firebrick", 
       las = 1, ylab = "Residuals", xlab = "Normal quantile", main = "")
