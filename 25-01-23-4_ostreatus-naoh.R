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
  # Values = c(z.scores1, z.scores2, z.scores3, z.scores4, z.scores5, z.scores6), # vector of trial values
  Values = c(o1, o2, o3, o4),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3)),
            rep("Ostreatus 4", length(o4))
))

g <- ggplot(df.long) +
  geom_line(aes(x = Time, y = Values,
                color = Trial)) +
  scale_color_manual(values = c("Ostreatus 1" = 'green',
                                "Ostreatus 2" = 'blue',
                                "Ostreatus 3" = 'orange',
                                "Ostreatus 4" = 'purple'))

g + geom_vline(xintercept=1674652020,color="red") +
  annotate("text", x=1674652020, y=20, label="a)") +
  geom_vline(xintercept=1674652530,color="blue") +
  annotate("text", x=1674652530, y=20, label="b)") +
  geom_vline(xintercept=1674653230,color="blue") +
  annotate("text", x=1674653230, y=20, label="c)") +
  geom_vline(xintercept=1674653730,color="red") +
  annotate("text", x=1674653730, y=20, label="d)") +
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

