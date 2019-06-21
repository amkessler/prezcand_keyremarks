# src: https://www.garrickadenbuie.com/blog/redacted-text-extracted-mueller-report/

# libraries ---------------------------------------------------------------
library(tidyverse)
library(ggpage)
library(tidytext)
library(stringr)

# read in saved remarks file ---------------------------------------------
keyremarks <- readRDS("keyremarks_forMP.rds")

remarks_fortext <- keyremarks %>% 
  filter(date > "2018-11-06") %>% 
  select(candidate,
         # category,
         text = key_sound
  ) 


# tidy texting ------------------------------------------------------------
tidy_remarks <- remarks_fortext %>%
  unnest_tokens(word, text)

# remove stop words
data(stop_words)

tidy_remarks <- tidy_remarks %>%
  anti_join(stop_words)

remarks_word_count <- tidy_remarks %>%
  count(candidate, word, sort = TRUE) %>%
  filter(!str_detect(word, "[0-9]")) %>% # remove numbers
  arrange(candidate, desc(n))




