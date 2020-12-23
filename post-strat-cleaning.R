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
library(haven)
library(tidyverse)
# Read in the raw data.
setwd("/Users/juliannelin/Desktop/Fall 2020/STA304 Final")

# Add the labels

# Just keep some variables that may be of interest (change 
# this depending on your interests)
gss2017 <- read_csv("gss.csv")
gss2017 <- gss2017 %>% select(religion_has_affiliation, age, education, province)


gss2017 <- gss2017 %>% mutate(religion= ifelse(religion_has_affiliation == "Has religious affiliation", 1, 0))
gss2017$age_range <- cut(gss2017$age, c(0, 17, 24, 34, 44, 54, 120), labels=c("Under 18", "18-24 years old", "25-34 years old", "35-44 years old", "45-54 years old", "55+ years old"))
gss2017<- gss2017[gss2017$age_range != "Under 18", ]
gss2017$education[gss2017$education == "Trade certificate or diploma"] <- "College, CEGEP or other non-university certificate or di..."
gss2017$education[gss2017$education == "University certificate or diploma below the bachelor's level"] <- "Bachelor's degree (e.g. B.A., B.Sc., LL.B.)"

gss2017 <- 
  gss2017 %>%
  count(age_range, province, religion, education) %>%
  group_by(province) 

# Saving the census data as a csv file in my
# working directory
write_csv(gss2017, "census_data.csv")



