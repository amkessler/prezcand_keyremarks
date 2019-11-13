# libraries ---------------------------------------------------------------
library(tidyverse)
library(ggpage)
library(tidytext)
library(stringr)
library(xlsx)

# read in saved remarks file ---------------------------------------------
keyremarks <- readRDS("keyremarks_forMP.rds")

remarks_fortext <- keyremarks %>% 
  filter(date > "2018-11-06") %>% 
  select(candidate,
         # category,
         text = key_sound
  ) 


#column for just last name of candidate
remarks_fortext$candidate <- str_replace_all(remarks_fortext$candidate, "Bill de Blasio", "Bill deBlasio")
remarks_fortext$lastname <- str_split(remarks_fortext$candidate, " ", simplify = TRUE)[,2]

remarks_fortext$candidate <- remarks_fortext$lastname
remarks_fortext$lastname <- NULL

remarks_fortext %>% 
  count(candidate) 


#filter to only ACTIVE CURRENT candidates
remarks_fortext <- remarks_fortext %>% 
  filter(candidate %in% c("Bennet",
                        "Biden",
                        "Booker",
                        "Bullock",
                        "Buttigieg",
                        "Castro",
                        "deBlasio",
                        "Delaney",
                        "Gabbard",
                        "Gillibrand",
                        "Harris",
                        "Hickenlooper",
                        "Inslee",
                        "Klobuchar",
                        "Messam",
                        "Moulton",
                        "O'Rourke",
                        "Sanders",
                        "Swalwell",
                        "Warren",
                        "Williamson",
                        "Yang")
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

#top words for each candidate
remarks_topwords_bycand <- remarks_word_count %>% 
  group_by(candidate) %>% 
  top_n(n = 20, wt = n) %>% #pulls top 10 by sumcontribs value
  ungroup()

#save to file
write.xlsx(remarks_topwords_bycand, "output/topwords_bycand.xlsx")




tidy_reports <- tidy_remarks %>% 
  rename(report = candidate)

raw_frequency <- tidy_reports %>%
  group_by(report) %>%
  count(word, sort = TRUE) %>%
  left_join(tidy_reports %>%
              group_by(report) %>%
              summarise(total = n())) %>%
  mutate(freq = n/total)

frequency <- raw_frequency %>%
  select(report, word, freq) %>%
  spread(report, freq) 
