# src: https://www.garrickadenbuie.com/blog/redacted-text-extracted-mueller-report/

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



#### GRAPHING OUT ####

# remove page bc we don't have it for watergate
# tidy_mueller <- tidy_mueller %>%
#   select(-page)
# 
# tidy_reports <- bind_rows(mutate(tidy_mueller, report = "Mueller"),
#                           mutate(tidy_watergate, report = "Watergate")) %>%
#   filter(!str_detect(word, "[0-9]"))


tidy_reports <- tidy_remarks %>% 
  rename(report = candidate)

# following: https://www.tidytextmining.com/twitter.html#word-frequencies-1
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


# %>%
#   arrange(Mueller, Watergate)


# plot relative frequencies of TWO CANDIDATES-----------------------------------------------
library(scales)

freq_plot <- ggplot(frequency, aes(Mueller, Watergate)) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.25, height = 0.25) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  geom_abline(color = "red") +
  hrbrthemes::theme_ipsum_rc() +
  labs(title = "Word frequencies in Mueller vs. Watergate Reports",
       subtitle = "Text from Mueller Report (2019), Watergate Special Prosecution Force Report (1975)",
       caption = "by @dataandme")

freq_plot

ggsave("img/mueller_watergate.jpg", freq_plot)
