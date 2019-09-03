library(shiny)
library(DT)
library(tidyverse)
library(lubridate)
library(janitor)
library(glue)

# keyremarks <- readRDS("keyremarks_forMP.rds")

#load from pubbed csv
raw_data <- read_csv("https://docs.google.com/spreadsheets/d/e/2PACX-1vQr33RqP-C0RlQgIYN9abAxVDPJa-Z3Q6tTQrvAgtKnIg5RQv99kevyKjlYMQ-B-Zx2WG5uMZyCkUur/pub?gid=735806909&single=true&output=csv",
                       col_types = cols(.default = "c"))


#process and format ####
keyremarks <- raw_data %>% 
  clean_names()

#convert to date format
keyremarks$date <- mdy(keyremarks$date)

#create top level categories
keyremarks <- keyremarks %>% 
  mutate(
    subcategories = str_to_lower(subject_1),
    category = case_when(
      str_detect(subcategories, "abortion") ~ "abortion",
      str_detect(subcategories, "roe vs. wade") ~ "abortion",
      str_detect(subcategories, "roe v. wade") ~ "abortion",
      str_detect(subcategories, "health care") ~ "healthcare",
      str_detect(subcategories, "healthcare") ~ "healthcare",
      str_detect(subcategories, "obamacare") ~ "healthcare",
      str_detect(subcategories, "medicare") ~ "healthcare",
      str_detect(subcategories, "tuition") ~ "tuition",
      str_detect(subcategories, "student debt") ~ "tuition",
      str_detect(subcategories, "college affordability") ~ "tuition",
      str_detect(subcategories, "guns") ~ "guns",
      str_detect(subcategories, "gun ") ~ "guns",
      str_detect(subcategories, "immigration") ~ "immigration",
      str_detect(subcategories, "immigrant") ~ "immigration",
      str_detect(subcategories, "migrant") ~ "immigration",
      str_detect(subcategories, "child separation") ~ "immigration",
      str_detect(subcategories, "border") ~ "immigration",
      str_detect(subcategories, "criminal justice") ~ "criminal justice",
      str_detect(subcategories, "cash bail") ~ "criminal justice",
      str_detect(subcategories, "racial justice") ~ "criminal justice",
      str_detect(subcategories, "economy") ~ "economy",
      str_detect(subcategories, "economic") ~ "economy",
      str_detect(subcategories, "minimum wage") ~ "economy",
      str_detect(subcategories, "living wage") ~ "economy",
      str_detect(subcategories, "wages") ~ "economy",
      str_detect(subcategories, "income") ~ "economy",
      str_detect(subcategories, "climate") ~ "climate"
    )
  )


#case of categories
keyremarks$category <- str_to_title(keyremarks$category)
keyremarks$subcategories <- str_to_title(keyremarks$subcategories)


#format as factors for DT use
keyremarks$category <- as.factor(keyremarks$category)
keyremarks$subcategories <- as.factor(keyremarks$subcategories)
keyremarks$candidate <- as.factor(keyremarks$candidate)
keyremarks$venue <- as.factor(keyremarks$venue)
keyremarks$state <- as.factor(keyremarks$state)
keyremarks$city <- as.factor(keyremarks$city)
keyremarks$subject_2 <- as.factor(keyremarks$subject_2)

# Select fields to display

names(keyremarks)

remarks_big <- keyremarks %>% 
  filter(date > "2018-11-06") %>% 
  select(candidate,
         date,
         city,
         state,
         venue,
         category,
         subcategories,
         tc_in,
         key_sound,
         tc_in_2,
         other_sound,
         other_sound_subcategories = subject_2,
         ms_number,
         on_cam
  ) %>% 
  arrange(desc(date))



### Now for the Shiny ####
shinyServer(function(input, output, session) {
  output$tbl_b = DT::renderDataTable(remarks_big,
                                     rownames = FALSE,
                                     filter = "top",
                                     extensions = 'Buttons',
                                     options = list(searchHighlight = TRUE,
                                                    dom = 'Bfrtip', 
                                                    buttons = c('copy', 'excel', 'print'))) 
                                 
})