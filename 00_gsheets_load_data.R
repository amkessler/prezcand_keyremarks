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
    subcategories = str_to_lower(subject_1),
    category = case_when(
      str_detect(subcategories, "abortion") ~ "abortion",
      str_detect(subcategories, "roe vs. wade") ~ "abortion",
      str_detect(subcategories, "roe v. wade") ~ "abortion",
      str_detect(subcategories, "health care") ~ "healthcare",
      str_detect(subcategories, "healthcare") ~ "healthcare",
      str_detect(subcategories, "obamacare") ~ "healthcare",
      str_detect(subcategories, "medicare") ~ "healthcare",
      str_detect(subcategories, "climate") ~ "climate",
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
      str_detect(subcategories, "income") ~ "economy"
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



#save to file
saveRDS(keyremarks, "keyremarks_forMP.rds")
write_csv(keyremarks, "keyremarks_forMP.csv")

