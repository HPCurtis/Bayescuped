data {
  int<lower=0> N;   // number of data items
  int<lower=0> K;   // number of predictors
  matrix[N, K] x;   // predictor matrix
  vector[N] y;      // outcome vector
}
parameters {
  vector[K] beta;       // coefficients for predictors
  real<lower=0> sigma;  // error scale
}
model {
  
  // Priors
  beta[1] ~ normal(0,2);
  beta[2] ~ normal(0,3);
  sigma ~ cauchy(0, 2);
  
  // Likelihood
  y ~ normal(x * beta, sigma);  // likelihood
}
