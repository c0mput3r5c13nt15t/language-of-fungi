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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/25-01-23-4_ostreatus-naoh.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ###############################################

start_time = 1674650820
end_time = 1674654420

o1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
o3 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
o4 = df$Trial4[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 4), # repeat time values by number of trials
  Values = c(o1, o2, o3, o4),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4))
))

g <- ggplot(df.long) +
  ggtitle("25. Januar 2023") +
  
  geom_vline(xintercept=1674651060,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674651060, y=30, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1674652020,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674652020, y=30, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1674652530,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674652530, y=30, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1674653230,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674653230, y=30, label="d)",size = 18/.pt) +
  geom_vline(xintercept=1674653730,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674653730, y=30, label="e)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial),alpha=0.7) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) + 
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) +
  theme(legend.position = c(.9, .85)) + 
  theme(legend.background = element_rect(fill = "white"))

png(file="./graphs/25-01-23-4_ostreatus-naoh.png",
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

