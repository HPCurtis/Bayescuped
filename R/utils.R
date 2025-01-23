generate_data <- function(alpha = 5, beta = 0, gamma = 3, delta = 2, n = 100, 
                          seed = 42) {
  set.seed(seed)
  
  # Individuals
  individual <- 1:n
  
  # Treatment status
  d <- rbinom(n, 1, 0.5)
  
  # Individual outcome pre-treatment
  y0 <- alpha + beta * d + rnorm(n, mean = 0, sd = 1)
  y1 <- y0 + gamma + delta * d + rnorm(n, mean = 0, sd = 1)
  
  # Create the data frame
  data <- data.frame(
    individual = individual,
    ad_campaign = d,
    revenue0 = y0,
    revenue1 = y1
  )
  
  return(data)
}

generate_priors <- function(n, seed = 42){
  
  library(fdrtool)
  set.seed(seed)
  
  # Individuals
  individual <- 1:n
  
  # Treatment status
  d <- rbinom(n, 1, 0.5)
  
  # Priors
  alpha_target <- rnorm(n=1, mean = 0, sd = 2)
  theta <- rnorm(n=1, mean = 0, sd = 2)
  sigma_theta <- rhcauchy(1, sigma = 1)

  alpha_cuped <- rnorm(1, 0, 2)
  beta_cuped <- rnorm(1, 0, 3)
  sigma_cuped <- rhcauchy(1, sigma = 1)

  # Transforms
  mu_theta <- alpha_target + theta * y_pre

}
  
summary_print<- function(sm){
  print(sm$summary())
}

percent_diff <- function(high_value, low_value) {
  ((high_value - low_value) / high_value) * 100
}

cuped_generator <- function(N){
  
}