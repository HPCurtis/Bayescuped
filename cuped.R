# Load project code. ----
source("utils.R")

# Statistical calculations. ----
diff_mean <- mean(d[d$ad_campaign==1,"revenue1" ]) - mean(d[d$ad_campaign==0,"revenue1" ])  
diff_mean

# The same can be achieved using ols lnear model.
# Model matrix
ols_fit <- lm(revenue1 ~ ad_campaign ,data = d)
summary(ols_fit)

dm = model.matrix(ols_fit)