library(shiny)
library(DT)
library(tidyverse)
library(lubridate)
library(janitor)
library(glue)

keyremarks <- readRDS("keyremarks_forMP.rds")

remarks_big <- keyremarks %>% 
  select(candidate,
         date,
         venue,
         city,
         state,
         subject_detailed = subject_1,
         key_sound,
         # subject_2,
         other_sound
         # source_link
  ) %>% 
  arrange(desc(date))


shinyServer(function(input, output, session) {
  output$tbl_b = DT::renderDataTable(remarks_big,
                                     rownames = FALSE,
                                     filter = "top",
                                     extensions = 'Buttons',
                                     options = list(searchHighlight = TRUE,
                                                    dom = 'Bfrtip', 
                                                    buttons = c('copy', 'excel', 'print'))) 
                                 
})