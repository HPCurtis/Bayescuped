# Load project code. ----
source("utils.R")

d <- generate_data()

# Statistical calculations. ----
diff_mean <- mean(d[d$ad_campaign==1,"revenue1" ]) - mean(d[d$ad_campaign==0,"revenue1" ])  
diff_mean

# The same can be achieved using ols linear model.
ols_fit <- lm(revenue1 ~ ad_campaign, data = d)
ols_summ <-summary(ols_fit)

# CUPED estimator
theta <- lm(revenue1 ~ revenue0, data = d)
theta <- theta$coefficients[2]

y_cuped <- d$revenue1 - theta * d$revenue0 - mean(d$revenue0)
d$y_cuped <- y_cuped

cuped_fit <- lm(y_cuped ~ ad_campaign, data = d) 
cuped_summ <- summary(cuped_fit)

# Calculate percentage difference of std error of estimators
ols_ste <- ols_summ$coefficients[4]
cuped_ste <- cuped_summ$coefficients[4]
percent_ste_diff <-percent_diff(high_value = ols_ste, low_value = cuped_ste)