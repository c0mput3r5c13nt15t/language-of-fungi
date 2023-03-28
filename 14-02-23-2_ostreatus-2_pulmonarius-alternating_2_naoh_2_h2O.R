# INSTALL AND LOAD PACKAGES ################################

library(datasets)
library('devtools')
library(pracma)
library(ggplot2)
library(tidyverse)
library(anytime)
library("viridis")

# Use pacman to load add-on packages as desired
pacman::p_load(pacman, rio,fluoR) 

# IMPORTING WITH RIO #######################################

# CSV
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/14-02-23-2_ostreatus-2_pulmonarius-alternating_2_naoh_2_h2O.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ################################################

start_time = 1676377800
end_time = 1676387100

o1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
p1 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
p2 = df$Trial4[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 4), # repeat time values by number of trials
  Values = c(o1, o2, p1, p2),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Pulmonarius 1", length(p1)),
            rep("Pulmonarius 2", length(p2))
))

g <- ggplot(df.long) +
  ggtitle("14. Februar 2023") +
  
  geom_vline(xintercept=1676382240,color="red",alpha=0.5) +
  annotate("text", x=1676382240, y=10, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1676382840,color="red",alpha=0.5) +
  annotate("text", x=1676382840, y=10, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1676383500,color="red",alpha=0.5) +
  annotate("text", x=1676383500, y=10, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1676384100,color="red",alpha=0.5) +
  annotate("text", x=1676384100, y=10, label="d)",size = 18/.pt) +
  geom_vline(xintercept=1676384700,color="red",alpha=0.5) +
  annotate("text", x=1676384700, y=10, label="e)",size = 18/.pt) +
  geom_vline(xintercept=1676385300,color="red",alpha=0.5) +
  annotate("text", x=1676385300, y=10, label="f)",size = 18/.pt) +
  geom_vline(xintercept=1676385900,color="red",alpha=0.5) +
  annotate("text", x=1676385900, y=10, label="g)",size = 18/.pt) +
  geom_vline(xintercept=1676386500,color="red",alpha=0.5) +
  annotate("text", x=1676386500, y=10, label="h)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial)) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M")))

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

