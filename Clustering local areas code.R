##### Load libraries
library(tidyverse)
library(tidymodels)
library(readxl)
library(janitor)

# Set working directory as current file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


##### Data preparation

### Population density variable

# Import population density variable
population_density <- read_excel("population_density.xlsx")

# Ensure attribute names are tidy
population_density <- population_density %>% clean_names()

# Create distinctive attribute names
population_density <- population_density %>% rename(population_density = observation)


### Age distribution variable

# Import age distribution variable
age_distribution <- read_excel("age_distribution.xlsx")

# Ensure attribute names are tidy
age_distribution <- age_distribution %>% clean_names()

# Remove irrelevant attributes
age_distribution <- age_distribution %>% subset(select = - c(age_3_categories_code))

# Convert from long to wide table
age_distribution <- age_distribution %>% pivot_wider(names_from = "age_3_categories", values_from = "observation")

# Ensure attribute names are tidy
age_distribution <- age_distribution %>% clean_names()

# Calculate total observations attribute
age_distribution <- age_distribution %>% mutate(total_observations = (aged_15_years_and_under + aged_16_to_64_years + aged_65_years_and_over))

# Convert age counts to proportions
age_distribution <- age_distribution %>% mutate_at(vars("aged_15_years_and_under", "aged_16_to_64_years", "aged_65_years_and_over"), ~ . / total_observations) 


### Final features dataset

# Bring features to single dataframe
local_area_data <- full_join(age_distribution, population_density, by = "westminster_parliamentary_constituencies")

# Check there is no missing data following join (desired result is 0 for each attribute)
local_area_data %>% map(~ sum(is.na(.)))

# Check there is one row per constituency. There should be 573 constituencies in England and Wales
nrow(local_area_data)

# Select only useful columns for clustering model
local_area_data <- local_area_data %>% select(westminster_parliamentary_constituencies, aged_15_years_and_under, aged_16_to_64_years, aged_65_years_and_over, population_density)

##### Data exploration

##### Model building

##### Model evaluation

##### Data visualisation

