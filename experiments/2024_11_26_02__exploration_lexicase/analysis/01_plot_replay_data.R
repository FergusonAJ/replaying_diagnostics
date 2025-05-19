rm(list = ls())

library(ggplot2)
library(dplyr)

df_replays = read.csv('../data/01_replay_data.csv')
df_replays = df_replays[df_replays$replay_gen != 50000,]
df_replays = df_replays[!is.na(df_replays$replay_gen),]
df_replays = df_replays[df_replays$gen + df_replays$replay_gen == 50000,]

color = '#004488'

plot_dir = '../plots'
if(!dir.exists(plot_dir)){
  dir.create(plot_dir)
}

df_summary = dplyr::group_by(df_replays, replay_gen, rep_id) %>%
  dplyr::summarize(
    fitness_max_mean = mean(fitness_max),
    fitness_max_max = max(fitness_max),
    fitness_max_min = min(fitness_max),
    fitness_max_median = median(fitness_max),
    fitness_max_sd = sd(fitness_max),
    count = dplyr::n()
  )

ggplot(df_replays[df_replays$replay_gen < 2000,], aes(x = as.factor(replay_gen), y = fitness_max)) + 
  geom_boxplot()

ggplot(df_replays[df_replays$replay_gen <= 1500,], aes(x = as.factor(replay_gen), y = fitness_max)) + 
  geom_jitter(height = 0, width = 0.2, alpha = 0.2)


ggplot(df_summary, aes(x = replay_gen, y = fitness_max_mean)) + 
  geom_line() + 
  geom_line(aes(y = fitness_max_median), color='red') +
  xlab('Replay generation') + 
  ylab('Maximum fitness of replay replicates')
ggsave(paste0(plot_dir, '/lexicase_replays_all.png'), unit = 'in', height = 6, width = 8)

ggplot(df_summary[df_summary$replay_gen < 5000,], aes(x = replay_gen, y = fitness_max_mean)) + 
  geom_line() + 
  geom_line(aes(y = fitness_max_median), color='red') 

z = 1.96 # 95% conf interval
df_summary$conf_int_lower = df_summary$fitness_max_mean - z * (df_summary$fitness_max_sd / sqrt(df_summary$count))
df_summary$conf_int_upper = df_summary$fitness_max_mean + z * (df_summary$fitness_max_sd / sqrt(df_summary$count))

ggplot(df_summary, aes(x = replay_gen, y = fitness_max_mean)) + 
  geom_ribbon(aes(ymin = conf_int_lower, ymax = conf_int_upper)) +
  geom_line() + 
  geom_line(aes(y = fitness_max_median), color='red') 

ggplot(df_summary[df_summary$replay_gen < 3000,], aes(x = replay_gen, y = fitness_max_mean)) + 
  geom_ribbon(aes(ymin = conf_int_lower, ymax = conf_int_upper), fill = color, alpha = 0.5) +
  #geom_errorbar(aes(ymin = conf_int_lower, ymax = conf_int_upper)) +
  geom_line() + 
  geom_line(aes(y = fitness_max_median), color='red')  + 
  xlab('Replay generation') + 
  ylab('Maximum fitness of replay replicates')
ggsave(paste0(plot_dir, '/lexicase_replays_zoomed.png'), unit = 'in', height = 6, width = 8)

