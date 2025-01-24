library(SBC)
library(cmdstanr)

source("utils.R")

# Parrallelise
options(mc.cores = parallel::detectCores())
cache_dir <- "./SBC_cache"

# Compile cmdstanr model
mod_cuped <- cmdstan_model(stan_file = "../stan/cuped.stan")

n_sims_generator <- SBC_generator_function(sbc_data_generator, N = 100)

cuped_datasets <- generate_datasets(n_sims_generator, 100)

cuped_backend <- SBC_backend_cmdstan_sample(
  mod_cuped, iter_warmup = 1000, iter_sampling = 1000, chains = 2)

results <- compute_SBC(cuped_datasets, cuped_backend, 
                       cache_mode = "results", 
                       cache_location = file.path(cache_dir, "results"))

print(results)
print(plot_rank_hist(results))
#plot_ecdf(results)
#plot_ecdf_diff(results)
