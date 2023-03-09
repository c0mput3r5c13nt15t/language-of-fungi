# INSTALL AND LOAD PACKAGES ################################

library(datasets)
library('devtools')
# devtools::install_github('atamalu/fluoR', build_vignettes = TRUE)
library(pracma)
library(ggplot2)
library(tidyverse)

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
e3 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
e4 = df$Trial4[df$Time >= start_time & df$Time <= end_time] # Messfehler
o1 = df$Trial5[df$Time >= start_time & df$Time <= end_time] # Messfehler
o2 = df$Trial6[df$Time >= start_time & df$Time <= end_time]
o3 = df$Trial7[df$Time >= start_time & df$Time <= end_time]
o4 = df$Trial8[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 7), # repeat time values by number of trials
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  Values = c(o1, o2, o3, o4, e1, e2),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4)),
            rep("Empty 1", length(e1)),
            rep("Empty 2", length(e2)),
))

g <- ggplot(df.long) +
  geom_line(aes(x = Time, y = Values,
                color = Trial)) +
  scale_color_manual(values = c("Ostreatus 1" = 'green',
                                "Ostreatus 2" = 'blue',
                                "Ostreatus 3" = 'orange',
                                "Ostreatus 4" = 'purple',
                                "Empty 1" = 'yellow',
                                "Empty 2" = 'yellow'))

g + geom_vline(xintercept=1678196700,color="red") +
  annotate("text", x=1678196700, y=40, label="a)") +
  geom_vline(xintercept=1678197600,color="red") +
  annotate("text", x=1678197600, y=40, label="b)") +
  geom_vline(xintercept=1678198500,color="red") +
  annotate("text", x=1678198500, y=40, label="c)") + 
  geom_vline(xintercept=1678199400,color="red") +
  annotate("text", x=1678199400, y=40, label="d)") + 
  geom_vline(xintercept=1678200300,color="red") +
  annotate("text", x=1678200300, y=40, label="e)") + 
  theme(text=element_text(size=18))

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

