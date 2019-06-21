library(tidyverse)
library(lubridate)
library(janitor)
library(glue)

keyremarks <- readRDS("keyremarks_forMP.rds")

remarks_sincemidterms <- keyremarks %>% 
  filter(date > "2018-11-06") %>% 
  select(candidate,
         date,
         venue,
         city,
         state,
         category,
         subcategories,
         key_sound,
         other_sound,
         source_link
  ) %>% 
  arrange(desc(date))


# some aggregate counts ####

remarks_sincemidterms %>% 
  filter(!is.na(category)) %>% 
  count(category) %>% 
  arrange(desc(n)) %>% 
  write_csv("output/total_bycategory.csv")


remarks_sincemidterms %>% 
  filter(!is.na(category)) %>% 
  count(candidate, category) %>% 
  arrange(candidate, desc(n)) %>% 
  write_csv("output/bycandidate_and_bycategory.csv")
