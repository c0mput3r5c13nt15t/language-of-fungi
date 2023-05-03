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
rio_csv_1 <- import("~/Development/R/language-of-fungi/data/csv/18-01-23-3_ostreatus-basispotenzial-1.csv")
rio_csv_2 <- import("~/Development/R/language-of-fungi/data/csv/18-01-23-3_ostreatus-basispotenzial-2.csv")
rio_csv_3 <- import("~/Development/R/language-of-fungi/data/csv/18-01-23-3_ostreatus-basispotenzial-3.csv")
rio_csv_4 <- import("~/Development/R/language-of-fungi/data/csv/18-01-23-3_ostreatus-basispotenzial-4.csv")

# REFORMATING WITH fluoR ###################################

df_1 <- format_data(rio_csv_1)
df_2 <- format_data(rio_csv_2)
df_3 <- format_data(rio_csv_3)
df_4 <- format_data(rio_csv_4)

df <- rbind(df_1, df_2, df_3, df_4)

# CALCULATE Z-SCORES #######################################

o1 = df$Trial1
o2 = df$Trial2
o3 = df$Trial3

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time, times = 3), # repeat time values by number of trials
  Values = c(o1,o2,o3),
  Trial = c(rep("Ostreatus 1", length(o1)),
            rep("Ostreatus 2", length(o2)),
            rep("Ostreatus 3", length(o3))
))

g <- ggplot(df.long) +
  ggtitle("18. Januar 2023") +
  
  geom_vline(xintercept=1674049230,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674049230, y=150, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1674050100,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674050100, y=150, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1674050420,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674050420, y=150, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1674051930,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674051930, y=150, label="d)",size = 18/.pt) +
  geom_vline(xintercept=1674052500,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674052500, y=150, label="e)",size = 18/.pt) +
  geom_vline(xintercept=1674052770,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674052770, y=150, label="f)",size = 18/.pt) +
  geom_vline(xintercept=1674053040,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674053040, y=150, label="g)",size = 18/.pt) +
  geom_vline(xintercept=1674053280,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1674053280, y=150, label="h)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial)) + 
  ylab("Spannung [mV]") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M")))+
  theme(legend.position = c(.15, .85)) + 
  theme(legend.background = element_rect(fill = "white"))

g

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear mind :)

