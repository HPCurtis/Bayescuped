# Bayesian CUPED

The following repo is small R based analysis proeject heavily inspired by [Matteo Courthoud](https://github.com/matteocourthoud/Blog-Posts/blob/main/notebooks/cuped.ipynb) and [Juan Orduz](https://juanitorduz.github.io/bayesian_cuped/). Specifically here is demonstration of the value of the causal inference method of CUPED (Controlled-Experiment using Pre-Experiment Data) that is finding paricular use in industry enviroments Xie & Aurisset (2016).

From both the standardly applied Ordinary Least Square methods and a Bayesian CUPED model implemented using the Stan probabalistic progamming language.

The analysis example here is a based around a simulated data set for Marketing company running an ad campaign and wanting to run A/B test to estimate the impact of the ad campaign on company revenue. The big difference here in this simulated example is that we have observed the  users revenue in the treatment (Served the ad) and the control (not ad campaign) pre-exposure.  

![plot](visualisations/revenues.png)

# Standard model (OLS)
```{r}
# Statistical calculations. ----
diff_mean <- mean(d[d$ad_campaign==1,"revenue1" ]) - mean(d[d$ad_campaign==0,"revenue1" ])  
diff_mean

# The same can be achieved using ols linear model.
ols_fit <- lm(revenue1 ~ ad_campaign ,data = d)
summary(ols_fit)
```
# CUPED Estimator

```
# CUPED estimator
theta <- lm(revenue1 ~ revenue0, data = d)
theta <- theta$coefficients[2]

y_cuped <- d$revenue1 - theta * d$revenue0 - mean(d$revenue0)
d$y_cuped <- y_cuped

cuped_fit <- lm(y_cuped ~ ad_campaign, data = d) 
cuped_summ <- summary(cuped_fit)
```

# Bayesian Model
<!---
TODO this  model need thought to presentation

$$
\begin{aligned}
\text{intercept-target} &\sim \mathrm{Normal}(\mu_0, \sigma_0) \\
\theta &\sim \mathrm{Normal}(0, \sigma_\theta^2) \\
\sigma_\theta &\sim \mathrm{HalfCauchy}(0, \tau_\theta) \\
\text{intercept-cuped} &\sim \mathrm{Normal}(\mu_1, \sigma_1) \\
\beta_{\mathrm{cuped}} &\sim \mathrm{Normal}(0, \sigma_\beta) \\
\sigma_{\mathrm{cuped}} &\sim \mathrm{HalfCauchy}(0, \tau_\beta) \\
y_{\mathrm{cuped}} &= y_{\mathrm{post}} - \theta \cdot (x_{\mathrm{pre}} - \mathbb{E}[x_{\mathrm{pre}}]) \\
y_{\mathrm{cuped, pred}} &\sim \mathrm{Normal}(\text{intercept}_{\text{cuped}} + \beta_{\mathrm{cuped}} \cdot x, \sigma_{\mathrm{cuped}}^2) \\
y_{\mathrm{post, pred}} &\sim \mathrm{Normal}(\text{intercept-target}, \sigma)
\end{aligned}
$$
-->

# References

Carpenter, B., Gelman, A., Hoffman, M. D., Lee, D., Goodrich, B., Betancourt, M., ... & Riddell, A. (2017). Stan: A probabilistic programming language. Journal of statistical software, 76.

Deng, A., Xu, Y., Kohavi, R., & Walker, T. (2013, February). Improving the sensitivity of online controlled experiments by utilizing pre-experiment data. In Proceedings of the sixth ACM international conference on Web search and data mining (pp. 123-132).

Xie, H., & Aurisset, J. (2016, August). Improving the sensitivity of online controlled experiments: Case studies at netflix. In Proceedings of the 22nd ACM SIGKDD International Conference on Knowledge Discovery and Data Mining (pp. 645-654).