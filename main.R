# INSTALL AND LOAD PACKAGES ################################

library(datasets)

library('devtools')
# devtools::install_github('atamalu/fluoR', build_vignettes = TRUE)
library(pracma)
library(ggplot2)
library(tidyverse)
library(anytime)

# Installs pacman ("package manager") if needed
if (!require("pacman")) install.packages("pacman")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, rio,fluoR) 

# IMPORTING WITH RIO #######################################

# CSV
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/01-03-23-4_pulmonarius-2_empty-naoh-binned_1min_ave.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE Z-SCORES #######################################

# No active influence
start_time = 1677679500
end_time = 1677683100

# Zutropfen
start_time = 1677681480
end_time = 1677687240

null_voltage = (df$Trial5[df$Time >= start_time & df$Time <= end_time] + df$Trial6[df$Time >= start_time & df$Time <= end_time])/2

t1 = df$Trial1[df$Time >= start_time & df$Time <= end_time] - null_voltage
t2 = df$Trial2[df$Time >= start_time & df$Time <= end_time] - null_voltage
t3 = df$Trial3[df$Time >= start_time & df$Time <= end_time] - null_voltage
t4 = df$Trial4[df$Time >= start_time & df$Time <= end_time] - null_voltage
t5 = df$Trial5[df$Time >= start_time & df$Time <= end_time] - null_voltage
t6 = df$Trial6[df$Time >= start_time & df$Time <= end_time] - null_voltage

z.scores1 <- z_score(xvals = t1,
                     mu = mean(t1), # manual input of mu/sigma optional;
                     sigma = sd(t1)) # used for example purposes

z.scores2 <- z_score(xvals = t2,
                    mu = mean(t2), # manual input of mu/sigma optional;
                    sigma = sd(t2)) # used for example purposes

z.scores3 <- z_score(xvals = t3,
                     mu = mean(t3), # manual input of mu/sigma optional;
                     sigma = sd(t3)) # used for example purposes

z.scores4 <- z_score(xvals = t4,
                     mu = mean(t4), # manual input of mu/sigma optional;
                     sigma = sd(t4)) # used for example purposes

z.scores5 <- z_score(xvals = t5,
                     mu = mean(t5), # manual input of mu/sigma optional;
                     sigma = sd(t5)) # used for example purposes

z.scores6 <- z_score(xvals = t6,
                     mu = mean(t6), # manual input of mu/sigma optional;
                     sigma = sd(t6)) # used for example purposes

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 6), # repeat time values by number of trials
  Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  # Values = c(t1, t2, t3, t4, t5, t6),
  Trial = c(rep("Ostreatus 1", length(t1)),
            rep("Ostreatus 2", length(t2)),
            rep("Ostreatus 3", length(t3)),
            rep("Ostreatus 4", length(t4)),
            rep("Leer 1", length(t5)),
            rep("Leer 2", length(t6))
))

g <- ggplot(df.long) +
  ggtitle("1. März 2023") +
  
  geom_hline(yintercept=1.65,alpha=0.3) + 
  annotate("text", x=start_time, y=1.65, label="1.65") +
  geom_hline(yintercept=-1.65,alpha=0.3) + 
  annotate("text", x=start_time, y=-1.65, label="-1.65") +
  
  geom_vline(xintercept=1677683620,color="red",alpha=0.5) +
  annotate("text", x=1677683620, y=8, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1677684840,color="red",alpha=0.5) +
  annotate("text", x=1677684840, y=8, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1677686040,color="red",alpha=0.5) +
  annotate("text", x=1677686040, y=8, label="c)",size = 18/.pt) + 
  
  geom_line(aes(x = Time, y = Values,
                color = Trial), alpha=0.7) + 
  ylab("z-Wert") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M")))

g

# Plot Normal distribution ################################ 

x <- z.scores3
y <- dnorm(x)
plot(x,y, type = "l", lwd = 2, axes = FALSE, xlab = "", ylab = "")

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

