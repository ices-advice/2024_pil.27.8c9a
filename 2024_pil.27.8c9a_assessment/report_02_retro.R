# Script information ------------------------------------------------------

# generate the tabs & figs for the report for pil.27.8c9a 

# Authors: Laura Wise (lwise@ipma.pt)
# Date: 2024/11/21

# Load packages -----------------------------------------------------------

library(tidyverse)
library(icesAdvice)



# Load data ---------------------------------------------------------------

load("./output/retro/retrospective.RData")

# Retrospective plot

ggplot(subset(all,param=="bio1plus"), aes(x=Year, y=Value/1000000,fill=peel))+
  geom_ribbon(aes(ymin = Lower/1000000, ymax = Upper/1000000), alpha=0.1,show.legend = F) +
  geom_line(size=1.2,aes(col=peel))+
  #theme_ipsum()+
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14))+
  labs(y="Biomass 1+, million tonnes",colour="Retro")
ggsave("report/retro/retroBio.png",width = 12,height = 8)


ggplot(subset(all,param=="rec"), aes(x=Year, y=Value/1000000,fill=peel))+
  geom_ribbon(aes(ymin = Lower/1000000, ymax = Upper/1000000), alpha=0.1,show.legend = F) +
  geom_line(size=1.2,aes(col=peel))+
  #theme_ipsum()+
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14))+
  labs(y="Age 0 recruits, billions",colour="Retro")
ggsave("report/retro/retroRecruits.png",width = 12,height = 8)

ggplot(subset(all,param=="f bar"), aes(x=Year, y=Value,fill=peel))+
  geom_ribbon(aes(ymin = Lower, ymax = Upper), alpha=0.1,show.legend = F) +
  geom_line(size=1.2,aes(col=peel))+
  #theme_ipsum()+
  theme(axis.text=element_text(size=14),
        axis.title=element_text(size=14),
        legend.text=element_text(size=14))+
  labs(y=latex2exp::TeX('$Fbar_{2-5}$'),colour="Retro")
ggsave("report/retro/retroFbar.png",width = 12,height = 8)
  
# End of script -----------------------------------------------------------

rm(list = ls())


