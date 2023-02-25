# INSTALL AND LOAD PACKAGES ################################

library(datasets)

library('devtools')
devtools::install_github('atamalu/fluoR', build_vignettes = TRUE)
library(pracma)
library(ggplot2)

# Installs pacman ("package manager") if needed
if (!require("pacman")) install.packages("pacman")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, rio,fluoR) 

# IMPORTING WITH RIO #######################################

# CSV
rio_csv <- import("~/Documents/PicoLog/14-02-23-2_ostreatus-2_pulmonarius-alternating_2_naoh_2_h20.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE Z-SCORES #######################################

z.scores1 <- z_score(xvals = df$Trial1,
                    mu = mean(df$Trial1), # manual input of mu/sigma optional;
                    sigma = sd(df$Trial1)) # used for example purposes

z.scores2 <- z_score(xvals = df$Trial2,
                    mu = mean(df$Trial2), # manual input of mu/sigma optional;
                    sigma = sd(df$Trial2)) # used for example purposes

z.scores3 <- z_score(xvals = df$Trial3,
                     mu = mean(df$Trial3), # manual input of mu/sigma optional;
                     sigma = sd(df$Trial3)) # used for example purposes

z.scores4 <- z_score(xvals = df$Trial4,
                     mu = mean(df$Trial4), # manual input of mu/sigma optional;
                     sigma = sd(df$Trial4)) # used for example purposes

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time, times = 4), # repeat time values by number of trials
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4), # vector of trial values
  Values = c(df$Trial1, df$Trial2, df$Trial3, df$Trial4),
  Trial = c(rep("1", length(df$Trial1)),
            rep("2", length(df$Trial2)),
            rep("3", length(df$Trial3)),
            rep("4", length(df$Trial4)))
)

ggplot(df.long) +
  geom_line(aes(x = Time, y = Values,
                color = Trial)) +
  scale_color_manual(values = c("1" = 'green',
                                "2" = 'blue',
                                "3" = 'orange',
                                "4" = 'purple'))

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

