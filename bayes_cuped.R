# Load project code. ----
source("utils.R")

# Libraries ----
library(patchwork)
library(cmdstanr)

options(mc.cores = parallel::detectCores())

d <- generate_data()
dm <- model.matrix(revenue1 ~ ad_campaign, data = d) 
  
# Compile the Stan models. 
mod_lm <- cmdstan_model(stan_file = "stan/lm.stan")
mod_cuped <- cmdstan_model(stan_file = "stan/cuped.stan")
mod_cuped_s <- cmdstan_model(stan_file = "stan/cuped_sensitivity.stan")

datalm_list <- list(N = nrow(d), K=ncol(dm),x = dm, y = d$revenue1)
bayes_fit <- mod_lm$sample(
  data = datalm_list,
  chains = 4
)

datacuped_list <- list(N = nrow(d), treatment = d$ad_campaign, y_pre = d$revenue0, y_post = d$revenue1)
bayescuped_fit <- mod_cuped$sample(
  data = datacuped_list,
  chains = 4
)

theta_mean = round(mean(bayescuped_fit$draws("theta")), 1)

data_sensitivity_list <- list(N = nrow(d), treatment = d$ad_campaign,
                              y_pre = d$revenue0, y_post = d$revenue1, theta = theta_mean)

bayescuped_s_fit <- mod_cuped_s$sample(
  data = data_sensitivity_list,
  chains = 4
)

# Print out the model summary
v_mods <- list(
  "Summary for Bayesain Regression model" = bayes_fit,
  "Summary for Bayesian Cuped model" = bayescuped_fit,
  "Summary for Bayesian Cuped sesitivity test" = bayescuped_s_fit
)
for (name in names(v_mods)) {
  cat(name, "\n")  # Print the associated message
  summary_print(v_mods[[name]])  # Call the function for the model
}