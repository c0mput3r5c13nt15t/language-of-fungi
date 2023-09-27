# INSTALL AND LOAD PACKAGES ################################

library(datasets)
library('devtools')
# devtools::install_github('atamalu/fluoR', build_vignettes = TRUE)
library(pracma)
library(ggplot2)
library(tidyverse)
library(anytime)
library("viridis")

# Installs pacman ("package manager") if needed
if (!require("pacman")) install.packages("pacman")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, rio,fluoR) 

# IMPORTING WITH RIO #######################################

# CSV
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/07-03-23-4_ostreatus-4_empty-naoh.csv")

# Binned CSV (average per minute)
# rio_csv <- import("~/Development/R/language-of-fungi/data/csv/07-03-23-4_ostreatus-4_empty-naoh-binned_1min_ave.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE Z-SCORES #######################################

start_time = 1678195980
end_time = 1678201140

null_voltage = (df$Trial1[df$Time >= start_time & df$Time <= end_time] + df$Trial2[df$Time >= start_time & df$Time <= end_time])/2

e1 = df$Trial1[df$Time >= start_time & df$Time <= end_time] - null_voltage
e2 = df$Trial2[df$Time >= start_time & df$Time <= end_time] - null_voltage
e3 = df$Trial3[df$Time >= start_time & df$Time <= end_time] # Messfehler
e4 = df$Trial4[df$Time >= start_time & df$Time <= end_time] # Messfehler
o1 = df$Trial5[df$Time >= start_time & df$Time <= end_time] - null_voltage
o2 = df$Trial6[df$Time >= start_time & df$Time <= end_time] - null_voltage
o3 = df$Trial7[df$Time >= start_time & df$Time <= end_time] - null_voltage
o4 = df$Trial8[df$Time >= start_time & df$Time <= end_time] - null_voltage

z.scores.o1 <- z_score(xvals = o1,
                     mu = mean(o1), # manual input of mu/sigma optional;
                     sigma = sd(o1)) # used for example purposes

z.scores.o2 <- z_score(xvals = o2,
                       mu = mean(o2), # manual input of mu/sigma optional;
                       sigma = sd(o2)) # used for example purposes

z.scores.o3 <- z_score(xvals = o3,
                       mu = mean(o3), # manual input of mu/sigma optional;
                       sigma = sd(o3)) # used for example purposes

z.scores.o4 <- z_score(xvals = o4,
                       mu = mean(o4), # manual input of mu/sigma optional;
                       sigma = sd(o4)) # used for example purposes

z.scores.e1 <- z_score(xvals = e1,
                       mu = mean(e1), # manual input of mu/sigma optional;
                       sigma = sd(e1)) # used for example purposes

z.scores.e2 <- z_score(xvals = e2,
                       mu = mean(e2), # manual input of mu/sigma optional;
                       sigma = sd(e2)) # used for example purposes

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 6), # repeat time values by number of trials
  # Values = c(z.scores.o1, z.scores.o2, z.scores.o3, z.scores.o4, z.scores.e1, z.scores.e2), # vector of trial values
  Values = c(o1,o2,o3,o4,e1,e2),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4)),
            rep("Leer 1", length(e1)),
            rep("Leer 2", length(e2))
))

g <- ggplot(df.long) +
  ggtitle("7. März 2023") +
  
  # geom_hline(yintercept=1.65,alpha=0.3, linetype="longdash") + 
  # annotate("text", x=start_time, y=1.65, label="1.65") +
  # geom_hline(yintercept=-1.65,alpha=0.3, linetype="longdash") + 
  # annotate("text", x=start_time, y=-1.65, label="-1.65") +
  
  geom_vline(xintercept=1678196700,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1678196700, y=16, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1678197600,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1678197600, y=16, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1678198500,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1678198500, y=16, label="c)",size = 18/.pt) + 
  geom_vline(xintercept=1678199400,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1678199400, y=16, label="d)",size = 18/.pt) + 
  geom_vline(xintercept=1678200300,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1678200300, y=16, label="e)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial), alpha=0.7) + 
  ylab("Spannungsdifferenz [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) +
  theme(legend.position = c(.915, .85)) + 
  theme(legend.background = element_rect(fill = "white"))

# attach -binned_1min_ave for binned data

png(file="./graphs/07-03-23-4_ostreatus-4_empty-naoh_difference.png",
    width=750, height=400)

g

dev.off()

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

