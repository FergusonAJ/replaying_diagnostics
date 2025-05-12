rm(list = ls())

library(ggplot2)
library(dplyr)

df_replays = read.csv('../data/02_early_replay_data.csv')
df_replays = df_replays[df_replays$replay_gen != 100,]

plot_dir = '../plots'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

color = '#DDAA33'

df_summary = dplyr::group_by(df_replays, replay_gen, rep_id) %>%
  dplyr::summarize(
    fitness_max_mean = mean(fitness_max),
    fitness_max_max = max(fitness_max),
    fitness_max_min = min(fitness_max),
    fitness_max_median = median(fitness_max)
  )

ggplot(df_replays, aes(x = as.factor(replay_gen), y = fitness_max)) + 
  geom_boxplot()

ggplot(df_summary, aes(x = replay_gen, y = fitness_max_mean)) + 
  geom_line()

ggplot(df_replays[df_replays$replay_gen <= 10,], aes(x = as.factor(replay_gen), y = fitness_max)) + 
  geom_boxplot(fill = color) + 
  xlab('Replay generation') + 
  ylab('Maximum fitness per replay replicate (N = 50)')
ggsave(paste0(plot_dir, '/tournament_early_replays.png'), unit = 'in', height = 6, width = 8)
