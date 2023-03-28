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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/25-01-23-4_ostreatus-naoh.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ###############################################

start_time = 1674650820
end_time = 1674654420

test = anytime(start_time)

o1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
o3 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
o4 = df$Trial4[df$Time >= start_time & df$Time <= end_time]

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

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 4), # repeat time values by number of trials
  # Values = c(z.scores.o1, z.scores.o2, z.scores.o3, z.scores.o4), # vector of trial values
  Values = c(o1, o2, o3, o4),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4))
))

g <- ggplot(df.long) +
  ggtitle("25. Januar 2023") +
  
  geom_vline(xintercept=1674651060,color="deepskyblue",alpha=0.5) +
  annotate("text", x=1674651060, y=30, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1674652020,color="red",alpha=0.5) +
  annotate("text", x=1674652020, y=30, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1674652530,color="limegreen",alpha=0.5) +
  annotate("text", x=1674652530, y=30, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1674653230,color="limegreen",alpha=0.5) +
  annotate("text", x=1674653230, y=30, label="d)",size = 18/.pt) +
  geom_vline(xintercept=1674653730,color="red",alpha=0.5) +
  annotate("text", x=1674653730, y=30, label="e)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial),alpha=0.7) + 
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

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

