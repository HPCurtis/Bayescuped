# Load project code.
source("utils.R")
# Load libraries
library(ggplot2)
library(patchwork)
library(cmdstanr)

options(mc.cores = parallel::detectCores())

d <- generate_data()

# Data vis
p1 <- ggplot(d, aes(revenue0, fill = as.factor(ad_campaign))) +
  geom_density(alpha = 0.5) + labs(title = "Revenue Pre Campaign",
                                   fill = "Ad Campaign", x = "") + theme(plot.title = element_text(hjust = 0.5))

p2 <- ggplot(d, aes(revenue1, fill = as.factor(ad_campaign))) +
  geom_density(alpha = 0.5) + labs(title = "Revenue Post Campaign",
                                   fill = "Ad Campaign", x = "Revenue") +
                                   theme(plot.title = element_text(hjust = 0.5))
p1/p2

# Statistical calculations.
diff_mean <- mean(d[d$ad_campaign==1,"revenue1" ]) - mean(d[d$ad_campaign==0,"revenue1" ])  
diff_mean

# The same can be achieved using ols lnear model.
# Model matrix
ols_fit <- lm(revenue1 ~ ad_campaign ,data = d)
summary(ols_fit)

dm = model.matrix(ols_fit)

# Bayesian section

# Compile the Stan models. 
mod_lm <- cmdstan_model(stan_file = "stan/lm.stan")
mod_cuped <- cmdstan_model(stan_file = "stan/cuped.stan")
mod_cuped_s <- cmdstan_model(stan_file = "stan/cuped_sensitivity.stan")

datalm_list <- list(N = nrow(d), K=ncol(dm),x = dm, y = d$revenue1)
bayes_fit <- mod_lm$sample(
  data = datalm_list,
  chains = 4
)

print(bayes_fit$summary())

datacuped_list <- list(N = nrow(d), treatment = d$ad_campaign, y_pre = d$revenue0, y_post = d$revenue1)
bayescuped_fit <- mod_cuped$sample(
  data = datacuped_list,
  chains = 4
)

print(bayescuped_fit$summary())

theta_mean = theta_mean

data_sensitivity_list <- list(N = nrow(d), treatment = d$ad_campaign,
                              y_pre = d$revenue0, y_post = d$revenue1, theta = theta_mean)

bayescuped_s_fit <- mod_cuped_s$sample(
  data = data_sensitivity_list,
  chains = 4
)

print(bayescuped_s_fit$summary())
