library(tidyverse)
library(lubridate)
library(janitor)
library(googlesheets)

#this will trigger a web page to authenticate with google account
# gs_ls() 


#register DW's 2020 google sheet
mykey <- Sys.getenv("DW2020_KEY")
dw2020 <- gs_key(mykey)

#open in brower
# dw2020 %>% 
#   gs_browse()

#list worksheets in the google sheet
gs_ws_ls(dw2020)


### KEY REMARKS AND INVERVIEWS ##########

#read in all the data in the interviews/remarks tab
keyremarks <- dw2020 %>%
  gs_read(ws = "Key Interviews/Remarks") %>%
  clean_names()

keyremarks %>%
  count(candidate) %>%
  arrange(desc(n))

#convert to date format
keyremarks$date <- mdy(keyremarks$date)

#create top level categories
keyremarks <- keyremarks %>% 
  mutate(
    subject_1 = str_to_lower(subject_1),
    category = case_when(
      str_detect(subject_1, "abortion") ~ "abortion",
      str_detect(subject_1, "roe vs. wade") ~ "abortion",
      str_detect(subject_1, "roe v. wade") ~ "abortion",
      str_detect(subject_1, "health care") ~ "healthcare",
      str_detect(subject_1, "healthcare") ~ "healthcare",
      str_detect(subject_1, "obamacare") ~ "healthcare",
      str_detect(subject_1, "medicare") ~ "healthcare",
      str_detect(subject_1, "climate") ~ "climate",
      str_detect(subject_1, "tuition") ~ "tuition - student debt",
      str_detect(subject_1, "student debt") ~ "tuition - student debt",
      str_detect(subject_1, "college affordability") ~ "tuition - student debt",
      str_detect(subject_1, "free college") ~ "tuition - student debt"
    )
  )


#format as factors for DT use
keyremarks$category <- as.factor(keyremarks$category)
keyremarks$subject_1 <- as.factor(keyremarks$subject_1)
keyremarks$candidate <- as.factor(keyremarks$candidate)
keyremarks$venue <- as.factor(keyremarks$venue)
keyremarks$state <- as.factor(keyremarks$state)


#save to file
saveRDS(keyremarks, "keyremarks_forMP.rds")


