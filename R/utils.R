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