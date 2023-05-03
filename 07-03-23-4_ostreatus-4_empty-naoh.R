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

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE Z-SCORES #######################################

start_time = 1678194600
end_time = 1678201140

e1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
e2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
e3 = df$Trial3[df$Time >= start_time & df$Time <= end_time] # Messfehler
e4 = df$Trial4[df$Time >= start_time & df$Time <= end_time] # Messfehler
o1 = df$Trial5[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial6[df$Time >= start_time & df$Time <= end_time]
o3 = df$Trial7[df$Time >= start_time & df$Time <= end_time]
o4 = df$Trial8[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 6), # repeat time values by number of trials
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  Values = c(o1, o2, o3, o4, e1, e2),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4)),
            rep("Leer 1", length(e1)),
            rep("Leer 2", length(e2))
))

g <- ggplot(df.long) +
  ggtitle("7. März 2023") +
  
  geom_vline(xintercept=1678196700,color="red", alpha=0.5, linetype="dashed") +
  annotate("text", x=1678196700, y=12, label="a)", size = 18/.pt) +
  geom_vline(xintercept=1678197600,color="red", alpha=0.5, linetype="dashed") +
  annotate("text", x=1678197600, y=12, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1678198500,color="red", alpha=0.5, linetype="dashed") +
  annotate("text", x=1678198500, y=12, label="c)",size = 18/.pt) + 
  geom_vline(xintercept=1678199400,color="red", alpha=0.5, linetype="dashed") +
  annotate("text", x=1678199400, y=12, label="d)", size = 18/.pt) + 
  geom_vline(xintercept=1678200300,color="red", alpha=0.5, linetype="dashed") +
  annotate("text", x=1678200300, y=12, label="e)", size = 18/.pt) + 
  
  geom_line(aes(x = Time, y = Values,
                color = Trial)) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) +
  theme(legend.position = c(.85, .15)) + 
  theme(legend.background = element_rect(fill = "white"))

png(file="./graphs/07-03-23-4_ostreatus-4_empty-naoh.png",
    width=750, height=400)

g

dev.off()

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear plots
dev.off()

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

