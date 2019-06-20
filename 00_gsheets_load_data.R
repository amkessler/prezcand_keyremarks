library(tidyverse)
library(lubridate)
library(janitor)
library(googlesheets)

#this will trigger a web page to authenticate with google account
gs_ls() 


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


#save to file
saveRDS(keyremarks, "keyremarks_forMP.rds")


