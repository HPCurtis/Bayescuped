# Load project code. ----
source("utils.R")
library(ggplot2)
library(patchwork)

d <- generate_data()

# Data visualisation ----
p1 <- ggplot(d, aes(revenue0, fill = as.factor(ad_campaign))) +
  geom_density(alpha = 0.5) + labs(title = "Revenue Pre Campaign",
                                   fill = "Ad Campaign", x = "") + theme(plot.title = element_text(hjust = 0.5))

p2 <- ggplot(d, aes(revenue1, fill = as.factor(ad_campaign))) +
  geom_density(alpha = 0.5) + labs(title = "Revenue Post Campaign",
                                   fill = "Ad Campaign", x = "Revenue") +
  theme(plot.title = element_text(hjust = 0.5))

joined_plot <- p1/p2

ggsave(filename = "../visualisations/revenues.png", joined_plot)