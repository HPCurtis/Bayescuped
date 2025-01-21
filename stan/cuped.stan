data {
  int<lower=0> N;   // number of data items
  vector[N] treatment;
  vector[N] y_post; 
  vector[N] y_pre;
}
transformed data{
  real m_ypre = mean(y_pre);
}
parameters {
  real intercept_target;
  real<lower=0> sigma_theta;  // error scale
  real theta;
  real intercept_cuped;
  real beta_cuped;
  real<lower=0> sigma_cuped;
}
transformed parameters{
  vector[N] mu_theta = intercept_target + theta * y_pre;
  vector[N] y_cuped = y_post - theta * (y_pre - m_ypre);
}
model {
  
  // Priors
  intercept_target ~ normal(0, 2);
  theta ~ normal(0, 3);
  sigma_theta ~ cauchy(0, 2);
  
  intercept_cuped ~ normal(0, 2);
  beta_cuped ~ normal(0, 3) ;
  sigma_cuped ~ cauchy(0, 2);
  
  y_post ~ normal(mu_theta, sigma_theta);
  y_cuped ~ normal(intercept_cuped + beta_cuped * treatment, sigma_cuped);

}
