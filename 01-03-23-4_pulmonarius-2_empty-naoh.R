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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/01-03-23-4_pulmonarius-2_empty-naoh.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE Z-SCORES #######################################

start_time = 1677679500
end_time = 1677687240

p1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
p2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
p3 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
p4 = df$Trial4[df$Time >= start_time & df$Time <= end_time]
e1 = df$Trial5[df$Time >= start_time & df$Time <= end_time]
e2 = df$Trial6[df$Time >= start_time & df$Time <= end_time]

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 6), # repeat time values by number of trials
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  Values = c(p1, p2, p3, p4, e1, e2),
  Trial = c(rep("Pulmonarius 1", length(p1)),
            rep("Pulmonarius 2", length(p2)),
            rep("Pulmonarius 3", length(p3)),
            rep("Pulmonarius 4", length(p4)),
            rep("Empty 1", length(e1)),
            rep("Empty 2", length(e2))
))

g <- ggplot(df.long) +
  geom_line(aes(x = Time, y = Values,
                color = Trial)) +
  scale_color_manual(values = c("Pulmonarius 1" = 'green',
                                "Pulmonarius 2" = 'blue',
                                "Pulmonarius 3" = 'orange',
                                "Pulmonarius 4" = 'purple',
                                "Empty 1" = 'yellow',
                                "Empty 2" = 'yellow'))

g + geom_vline(xintercept=1677683620,color="red") +
  annotate("text", x=1677683620, y=20, label="a)") +
  geom_vline(xintercept=1677684840,color="red") +
  annotate("text", x=1677684840, y=20, label="b)") +
  geom_vline(xintercept=1677686040,color="red") +
  annotate("text", x=1677686040, y=20, label="c)") + 
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

