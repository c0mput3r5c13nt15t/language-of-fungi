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
rio_csv <- import("~/Development/R/language-of-fungi/data/csv/14-02-23-2_ostreatus-2_pulmonarius-alternating_2_naoh_2_h2O.csv")

# REFORMATING WITH fluoR ###################################

df <- format_data(rio_csv)

# CALCULATE ################################################
             
start_time = 1676382100
end_time =   1676387100

o1 = df$Trial1[df$Time >= start_time & df$Time <= end_time]
o2 = df$Trial2[df$Time >= start_time & df$Time <= end_time]
p1 = df$Trial3[df$Time >= start_time & df$Time <= end_time]
p2 = df$Trial4[df$Time >= start_time & df$Time <= end_time]

z.scores1 <- z_score(xvals = o1,
                     mu = mean(o1), # manual input of mu/sigma optional;
                     sigma = sd(o1)) # used for example purposes

z.scores2 <- z_score(xvals = o2,
                     mu = mean(o2), # manual input of mu/sigma optional;
                     sigma = sd(o2)) # used for example purposes

z.scores3 <- z_score(xvals = p1,
                     mu = mean(p1), # manual input of mu/sigma optional;
                     sigma = sd(p1)) # used for example purposes

z.scores4 <- z_score(xvals = p2,
                     mu = mean(p2), # manual input of mu/sigma optional;
                     sigma = sd(p2)) # used for example purposes

# VISUALIZE ################################################

df.long <- data.frame(
  Time = rep(df$Time[df$Time >= start_time & df$Time <= end_time], times = 2), # repeat time values by number of trials
  Values = c(z.scores1, z.scores3),
  Trial = c(rep("Ostreatus 1", length(z.scores1)),
            rep("Pulmonarius 1", length(z.scores3))
))

g <- ggplot(df.long) +
  ggtitle("14. Februar 2023") +
  
  geom_hline(yintercept=1.65,alpha=0.3, linetype="longdash") + 
  annotate("text", x=start_time, y=1.65, label="1.65") +
  geom_hline(yintercept=-1.65,alpha=0.3, linetype="longdash") + 
  annotate("text", x=start_time, y=-1.65, label="-1.65") +
  
  geom_vline(xintercept=1676382240,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676382240, y=10, label="a)",size = 18/.pt) +
  geom_vline(xintercept=1676382840,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676382840, y=10, label="b)",size = 18/.pt) +
  geom_vline(xintercept=1676383500,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676383500, y=10, label="c)",size = 18/.pt) +
  geom_vline(xintercept=1676384100,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676384100, y=10, label="d)",size = 18/.pt) +
  geom_vline(xintercept=1676384700,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676384700, y=10, label="e)",size = 18/.pt) +
  geom_vline(xintercept=1676385300,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676385300, y=10, label="f)",size = 18/.pt) +
  geom_vline(xintercept=1676385900,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676385900, y=10, label="g)",size = 18/.pt) +
  geom_vline(xintercept=1676386500,color="red",alpha=0.5, linetype="dashed") +
  annotate("text", x=1676386500, y=10, label="h)",size = 18/.pt) +
  
  geom_line(aes(x = Time, y = Values,
                color = Trial)) + 
  ylab("z-Wert") +
  xlab("Zeit") +
  theme_minimal() + 
  theme(text=element_text(size=18)) +
  scale_colour_viridis_d() + 
  scale_x_continuous(labels = (function(var) format(anytime(var), "%H:%M"))) + 
  theme(legend.position = c(.9, .6)) + 
  theme(legend.background = element_rect(fill = "white"))

png(file="./graphs/14-02-23-2_ostreatus-2_pulmonarius-alternating_2_naoh_2_h2O_z-scores.png", width=750, height=400)

g

# dev.off()

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

