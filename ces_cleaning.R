#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from IPUMS USA
# Author: Jo-Yen Lin
# Data: November 2, 2020
# Contact: julianne.lin@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
devtools::install_github("hodgettsp/cesR")
library(cesR)
library(labelled)
library(tidyverse)
setwd("/Users/juliannelin/Desktop/Fall 2020/STA304 Final")
get_ces("ces2019_2019")
ces2019_phone <- to_factor(ces2019_phone)


# Clean the data and ignore unknown data points

# Select Parties
ces2019_phone <- ces2019_phone %>% mutate(vote_lib = ifelse(q11 =="(1) Liberal (Grits)", 1, 0)) 
ces2019_phone <- ces2019_phone %>% mutate(vote_con = ifelse(q11 =="(2) Conservatives (Tory, PCs, Conservative Party of Canada)", 1, 0)) 
ces2019_phone <- ces2019_phone %>% mutate(vote_ndp = ifelse(q11 =="(3) NDP (New Democratic Party, New Democrats, NDPers)", 1, 0))

# Clean religion
ces2019_phone <- ces2019_phone %>% mutate(religion = ifelse(q62 %in% c("(-9) Don't know / Agnostic", "(-8) Refused","(-7) Skipped", "(21) None, don't have one / Atheist"), 0, 1))


# Clean education 
ces2019_phone <- ces2019_phone[!(ces2019_phone$q61 %in% c("(-9) Don't know", "(-8) Refused","(-7)) Skipped")), ]
ces2019_phone <- ces2019_phone %>% mutate(education =case_when(
  q61 %in% c("(1) No schooling", "(2) Some elementary school","(3) Completed elementary school","(4) Some secondary / high school")~ "Less than high school diploma or its equivalent", 
  q61 == "(5) Completed secondary / high school" ~ "High school diploma or a high school equivalency certificate",
  q61 %in% c("(6) Some technical, community college, CEGEP, College Classi", "(7) Completed technical, community college, CEGEP, College C") ~"College, CEGEP or other non-university certificate or di...", 
  q61 %in% c("(8) Some university", "(9) Bachelor's degree") ~ "Bachelor's degree (e.g. B.A., B.Sc., LL.B.)",
  q61 %in% c("(10) Master's degree", "(11) Professional degree or doctorate") ~ "University certificate, diploma or degree above the bach..." 
))

# Clean Province 
ces2019_phone <- ces2019_phone[!(ces2019_phone$q4 %in% c("(-9) Don't know", "(-8) Refused","(-7)) Skipped", "(12) Yukon", "(13) Nunavut", "(11) Northwest Territories" )), ]
ces2019_phone <- ces2019_phone %>% mutate(province = case_when(
  q4 == "(1) Newfoundland and Labrador" ~"Newfoundland and Labrador", 
  q4 == "(2) Prince Edward Island" ~"Prince Edward Island",
  q4 == "(3) Nova Scotia"~"Nova Scotia",
  q4 == "(4) New Brunswick" ~"New Brunswick",
  q4 == "(5) Quebec" ~ "Quebec",
  q4 == "(6) Ontario"~"Ontario" , 
  q4 == "(7) Manitoba" ~"Manitoba",  
  q4 == "(8) Saskatchewan" ~ "Saskatchewan",
  q4 == "(9) Alberta" ~ "Alberta", 
  q4 == "(10) British Columbia" ~"British Columbia"))

# Clean 

ces2019_phone <- ces2019_phone[!(ces2019_phone$age_range %in% c("(-9) Don't know", "(-8) Refused","(-7)) Skipped")), ]
ces2019_phone <- ces2019_phone %>% mutate(age_range = case_when(
  age_range ==  "(1) 18-24 years old" ~ "18-24 years old",
  age_range ==  "(2) 25-34 years old" ~ "25-34 years old",
  age_range ==  "(3) 35-44 years old" ~ "35-44 years old",
  age_range ==  "(4) 45-54 years old" ~ "45-54 years old",
  age_range ==  "(5) 55+ years old" ~ "55+ years old",
)) 
ces2019_phone <- ces2019_phone %>% select(education, age_range, religion,province, vote_lib, vote_con, vote_ndp)


# Saving the census data as a csv file in my working directory
write_csv(ces2019_phone, "ces2019_data.csv")



