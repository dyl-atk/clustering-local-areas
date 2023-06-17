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

##### Data exploration

##### Model building

##### Model evaluation

##### Data visualisation

