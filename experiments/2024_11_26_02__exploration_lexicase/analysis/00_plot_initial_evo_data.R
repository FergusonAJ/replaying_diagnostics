rm(list = ls())

library(ggplot2)
source("https://gist.githubusercontent.com/benmarwick/2a1bb0133ff568cbe28d/raw/fb53bd97121f7f9ce947837ef1a4c65a73bffb3f/geom_flat_violin.R")

df_evo = read.csv('../data/00_final_evo_data.csv')

plot_dir = '../plots'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

color = '#004488'

ggplot(df_evo, aes(x = fitness_max)) + 
  geom_histogram(binwidth = 100)


ggplot(df_evo, aes(x = 0, y = fitness_max)) + 
  #geom_boxplot(width = 0.2) + 
  #geom_jitter(position = position_dodge2(width = 0.2, )) + 
  #geom_flat_violin(width = 0.2) + 
  geom_flat_violin(
    position = position_nudge(x = .2, y = 0),
    alpha = .8, 
    fill = color
  ) +
  geom_boxplot(
    width = .1,
    outlier.shape = NA,
    alpha = 0.5, 
    fill = color
  ) +
  geom_point(
    position = position_jitter(width = .15, height = 0),
    size = .5,
    alpha = 0.8
  ) +
  scale_y_continuous(limits = c(0,10^4+100)) + 
  xlab('') + 
  ylab('Maximum fitness of each replicate (N=50)') + 
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) + 
  ggtitle('Lexicase')
ggsave(paste0(plot_dir, '/lexicase_evo_results.png'), unit = 'in', height = 6, width = 4)

ggplot(df_evo, aes(x = 0, y = fitness_max)) + 
  #geom_boxplot(width = 0.2) + 
  #geom_jitter(position = position_dodge2(width = 0.2, )) + 
  #geom_flat_violin(width = 0.2) + 
  geom_flat_violin(
    position = position_nudge(x = .2, y = 0),
    alpha = .8, 
    fill = color
  ) +
  geom_boxplot(
    width = .1,
    outlier.shape = NA,
    alpha = 0.5, 
    fill = color
  ) +
  geom_point(
    position = position_jitter(width = .15, height = 0),
    size = .5,
    alpha = 0.8
  ) +
  xlab('') + 
  ylab('Maximum fitness of each replicate (N=50)') + 
  theme(axis.ticks.x = element_blank(), axis.text.x = element_blank()) + 
  ggtitle('Lexicase')
ggsave(paste0(plot_dir, '/lexicase_evo_results_zoomed.png'), unit = 'in', height = 6, width = 4)
