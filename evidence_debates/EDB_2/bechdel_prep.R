require(tidyverse)

# Run with the working directory set to this script's folder (evidence_debates/EDB_2/)
# so the ggsave()/write_csv() calls below land in ./assets alongside index.html.

df <- read_rds("https://github.com/jbisbee1/DS1000_F2024/raw/main/data/mv.Rds")

toplot <- df %>%
  mutate(bechdel_pass = bechdel_score > 1) %>%
  drop_na(bechdel_pass) %>%
  group_by(bechdel_pass) %>%
  mutate(med_gross = median(gross,na.rm=T),
         med_budg = median(budget,na.rm=T)) %>%
  ungroup() %>%
  mutate(budget_bin = cut(budget,breaks = c(1e06,1e07,1e08,Inf),
                          labels = c('Low budget\n$1m-$10m',
                                     'Medium budget\n$10m-$100m',
                                     'Big budget\n$100m+')))

toplot %>%
  ggplot(aes(x = bechdel_pass,y= gross)) + 
  geom_boxplot() + 
  geom_label(data = toplot %>%
              select(bechdel_pass,med_gross) %>%
              distinct(),
            aes(x = bechdel_pass,y = med_gross,label = paste0('$',scales::comma(round(med_gross))))) +  
  scale_y_log10(labels = scales::dollar) + 
  scale_x_discrete(labels = c('Fail','Pass')) + 
  labs(x = 'Passes the Bechdel Test',
       y = 'Gross box office revenue (log scale)',
       title = 'Box-office revenue by Bechdel test result') + 
  theme_minimal()

ggsave(filename = 'assets/evidence_A_bechdel_gross.png',width = 9,height = 6)

toplot %>%
  ggplot(aes(x = bechdel_pass,y = budget)) + 
  geom_boxplot() + 
  geom_label(data = toplot %>%
               select(bechdel_pass,med_budg) %>%
               distinct(),
             aes(x = bechdel_pass,y = med_budg,label = paste0('$',scales::comma(round(med_budg))))) +  
  scale_y_log10(labels = scales::dollar) + 
  scale_x_discrete(labels = c('Fail','Pass')) + 
  labs(x = 'Passes the Bechdel Test',
       y = 'Movie budget (log scale)',
       title = 'Movie budget by Bechdel test result') + 
  theme_minimal()

ggsave(filename = 'assets/evidence_B1_bechdel_budget.png',width = 9,height = 6)


toplot %>%
  drop_na(bechdel_pass) %>%
  ggplot(aes(x = budget,y = gross)) + 
  geom_point() + 
  scale_x_log10(labels = scales::dollar) + 
  scale_y_log10(labels = scales::dollar) + 
  theme_minimal() + 
  labs(x = 'Movie budget (log scale)',
       y = 'Box-office revenue (log scale)',
       title = 'Box-office revenue by movie budget')

ggsave(filename = 'assets/evidence_B2_budget_gross.png',width = 9,height = 6)


toplot %>%
  drop_na(budget_bin) %>%
  ggplot(aes(x = bechdel_pass,y = gross)) + 
  geom_boxplot() + 
  scale_y_log10(labels = scales::dollar) + 
  facet_wrap(~budget_bin,nrow = 1) + 
  theme_minimal() + 
  scale_x_discrete(labels = c('Fail','Pass')) + 
  labs(x = 'Passes the Bechdel test',
       y = 'Box-office revenue (log scale)',
       title = 'Box-office revenue by Bechdel test and budget')

ggsave(filename = 'assets/evidence_C_bechdel_gross_by_budget.png',width = 9,height = 6)

forCSV <- toplot %>%
  group_by(bechdel_pass,budget_bin) %>%
  summarise(med_gross = median(gross,na.rm=T)) %>%
  drop_na() %>%
  mutate(evidence = 'evidence_C') %>%
  bind_rows(toplot %>% select(bechdel_pass,med_gross) %>%
              distinct() %>%
              mutate(evidence = 'evidence_A')) %>%
  bind_rows(toplot %>% select(bechdel_pass,med_budg) %>%
              distinct() %>%
              mutate(evidence = 'evidence_B1'))

write_csv(forCSV,file = 'assets/underlying_summaries.csv')
