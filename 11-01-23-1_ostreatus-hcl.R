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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/11-01-23-1_ostreatus-hcl.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ###############################################

start_time = 1673445449
end_time = 1673446022

o1a = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o1b = df$Trial2[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 2), # repeat time values by number of trials
  Values = c(o1a, o1b),
  Trial = c(rep("Ostreatus 1a", length(o1a)),
            rep("Ostreatus 1b", length(o1b))
))

g <- ggplot(df.long) +
  ggtitle("11. Januar 2023") +
  
  geom_vline(xintercept=1673445837,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1673445837, y=40, label="a)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial),alpha=0.7) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) + 
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) +
  theme(legend.position = c(.15, .85)) + 
  theme(legend.background = element_rect(fill = "white"))

png(file="./graphs/11-01-23-1_ostreatus-hcl.png",  width=750, height=400)

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

