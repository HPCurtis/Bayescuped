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
  
summary_print<- function(sm){
  print(sm$summary())
}

percent_diff <- function(high_value, low_value) {
  ((high_value - low_value) / high_value) * 100
}
N <- 100
sbc_data_generator <- function(N) {

  # Generate data based on the prior distributions
  intercept_target <- rnorm(1, mean = 0, sd = 2)
  theta <- rnorm(1, mean = 0, sd = 3)
  sigma_theta <- abs(rcauchy(1, location = 0, scale = 2))
  
  intercept_cuped <- rnorm(1, mean = 0, sd = 2)
  beta_cuped <- rnorm(1, mean = 0, sd = 3)
  sigma_cuped <- abs(rcauchy(1, location = 0, scale = 2))
  
  # Generate predictors
  treatment <- rbinom(N, 1, 0.5)
  y_pre <- rnorm(N, mean = 0, sd = 1)
  
  # Transformed data
  m_ypre <- mean(y_pre)
  
  # Simulate y_post and y_cuped based on the model
  mu_theta <- intercept_target + theta * y_pre
  y_post <- rnorm(N, mean = mu_theta, sd = sigma_theta)
  
  y_cuped <- y_post - theta * (y_pre - m_ypre)
  
  # Return the generated data
  list(
    variables = list(
      intercept_target = intercept_target,
      theta = theta,
      sigma_theta = sigma_theta,
      intercept_cuped = intercept_cuped,
      beta_cuped = beta_cuped,
      sigma_cuped = sigma_cuped
    ),
    generated = list(
    N = N,
    treatment = treatment,
    y_pre = y_pre,
    y_post = y_post,
    m_ypre = m_ypre
    )
  )
}