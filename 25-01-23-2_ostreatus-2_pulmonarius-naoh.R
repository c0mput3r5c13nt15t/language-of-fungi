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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/25-01-23-2_ostreatus-2_pulmonarius-naoh.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ################################################

start_time = 1674656003
end_time = 1674659363

o1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
p1 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
p2 = df$Trial4[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 4), # repeat time values by number of trials
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  Values = c(o1, o2, p1, p2),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Pulmonarius 1", length(p1)),
            rep("Pulmonarius 2", length(p2))
))

g <- ggplot(df.long) +
  ggtitle("25. Januar 2023") +
  
  geom_vline(xintercept=1674656700,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674656700, y=12, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1674657300,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674657300, y=12, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1674657900,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674657900, y=12, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1674658500,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674658500, y=12, label="d)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial),alpha=0.7) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) + 
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) + 
  theme(legend.position = c(.87, .9)) + 
  theme(legend.background = element_rect(fill = "white"))

g

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

