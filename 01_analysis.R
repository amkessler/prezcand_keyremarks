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


#column for just last name of candidate
remarks_sincemidterms$candidate <- str_replace_all(remarks_sincemidterms$candidate, "Bill de Blasio", "Bill deBlasio")
remarks_sincemidterms$lastname <- str_split(remarks_sincemidterms$candidate, " ", simplify = TRUE)[,2]

remarks_sincemidterms$candidate <- remarks_sincemidterms$lastname
remarks_sincemidterms$lastname <- NULL

remarks_sincemidterms %>% 
  count(candidate) 


#filter to only ACTIVE CURRENT candidates
remarks_sincemidterms <- remarks_sincemidterms %>% 
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
