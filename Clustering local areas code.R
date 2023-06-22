##### Load libraries
library(tidyverse)
library(tidymodels)
library(readxl)
library(janitor)
library(cluster)
library(factoextra)
library(corrplot)
library(sf)
library(tmap)

# Set working directory as current file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


##### Data preparation

### Population density variable

# Import population density variable
population_density <- read_excel("population_density.xlsx")

# Ensure attribute names are tidy
population_density <- population_density %>% clean_names()

# Create distinctive attribute name
population_density <- population_density %>% rename(pop_density = observation)


### Distance to work variable

# Import variable
distance_to_work <- read_excel("distance_to_work.xlsx")

# Ensure attribute names are tidy
distance_to_work <- distance_to_work %>% clean_names()

# Remove irrelevant attributes
distance_to_work <- distance_to_work %>% subset(select = - c(distance_travelled_to_work_4_categories_code))

# Convert from long to wide table
distance_to_work <- distance_to_work %>% pivot_wider(names_from = "distance_travelled_to_work_4_categories", values_from = "observation")

# Ensure attribute names are tidy
distance_to_work <- distance_to_work %>% clean_names()

# Calculate total observations attribute
distance_to_work <- distance_to_work %>% mutate(total_observations = (less_than_10km + x10km_and_over + works_mainly_from_home + not_in_employment_or_works_mainly_offshore_in_no_fixed_place_or_outside_the_uk))

# Remove irrelevant attributes
distance_to_work <- distance_to_work %>% subset(select = - c(not_in_employment_or_works_mainly_offshore_in_no_fixed_place_or_outside_the_uk))

# Convert age counts to proportions
distance_to_work <- distance_to_work %>% mutate_at(vars("less_than_10km", "x10km_and_over", "works_mainly_from_home"), ~ . / total_observations) 


### Education variable

# Import variable
education <- read_excel("education.xlsx")

# Ensure attribute names are tidy
education <- education %>% clean_names()

# Remove irrelevant attributes
education <- education %>% subset(select = - c(highest_level_of_qualification_7_categories))

# Convert from long to wide table
education <- education %>% pivot_wider(names_from = "highest_level_of_qualification_7_categories_code", values_from = "observation")

# Rename attributes
education <- education %>% rename(does_not_apply = "-8", no_qual = "0", level_1_qual = "1", level_2_qual = "2", level_3_qual = "3", level_4_or_above_qual = "4", other_qual = "5")

# Calculate total observations attribute
education <- education %>% mutate(total_observations = (does_not_apply + no_qual + level_1_qual + level_2_qual + level_3_qual + level_4_or_above_qual + other_qual))

# Remove irrelevant attributes
education <- education %>% subset(select = - c(does_not_apply))

# Convert age counts to proportions
education <- education %>% mutate_at(vars("no_qual", "level_1_qual", "level_2_qual", "level_3_qual", "level_4_or_above_qual", "other_qual"), ~ . / total_observations) 


### Health variable

# Import variable
health <- read_excel("health.xlsx")

# Ensure attribute names are tidy
health <- health %>% clean_names()

# Remove irrelevant attributes
health <- health %>% subset(select = - c(general_health_3_categories_code))

# Convert from long to wide table
health <- health %>% pivot_wider(names_from = "general_health_3_categories", values_from = "observation")

# Ensure attribute names are tidy
health <- health %>% clean_names()

# Calculate total observations attribute
health <- health %>% mutate(total_observations = (does_not_apply + good_health + not_good_health))

# Remove irrelevant attributes
health <- health %>% subset(select = - c(does_not_apply))

# Convert age counts to proportions
health <- health %>% mutate_at(vars("good_health", "not_good_health"), ~ . / total_observations) 


### Age distribution variable

# Import variable variable
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


### Employment variable

# Import variable
employment <- read_excel("employment.xlsx")

# Ensure attribute names are tidy
employment <- employment %>% clean_names()

# Remove irrelevant attributes
employment <- employment %>% subset(select = - c(economic_activity_status_last_week_3_categories_code))

# Convert from long to wide table
employment <- employment %>% pivot_wider(names_from = "economic_activity_status_last_week_3_categories", values_from = "observation")

# Ensure attribute names are tidy
employment <- employment %>% clean_names()

# Calculate total observations attribute
employment <- employment %>% mutate(total_observations = (does_not_apply + employed + not_employed))

# Remove irrelevant attributes
employment <- employment %>% subset(select = - c(does_not_apply))

# Convert age counts to proportions
employment <- employment %>% mutate_at(vars("employed", "not_employed"), ~ . / total_observations) 


### Final features dataset

# Bring features to single dataframe
local_area_data <- full_join(age_distribution, population_density, by = "westminster_parliamentary_constituencies_code") %>%
  full_join(., health, by = "westminster_parliamentary_constituencies_code") %>%
  full_join(., education, by = "westminster_parliamentary_constituencies_code") %>%
  full_join(., distance_to_work, by = "westminster_parliamentary_constituencies_code") %>%
  full_join(., employment, by = "westminster_parliamentary_constituencies_code")

# Remove .x at end of constituency name attribute
local_area_data <- local_area_data %>% rename(westminster_parliamentary_constituencies = westminster_parliamentary_constituencies.x)

# Check there is no missing data following join (desired result is 0 for each attribute)
local_area_data %>% map(~ sum(is.na(.)))

# Check there is one row per constituency. There should be 573 constituencies in England and Wales
nrow(local_area_data)

# Create data frame of constituency names and codes
local_area_names <- local_area_data %>% select(westminster_parliamentary_constituencies_code, westminster_parliamentary_constituencies)

# Select only useful columns for clustering model
local_area_data <- local_area_data %>% select(westminster_parliamentary_constituencies, aged_15_years_and_under, aged_16_to_64_years, aged_65_years_and_over, pop_density, good_health, not_good_health, no_qual, level_1_qual, level_2_qual, level_3_qual, level_4_or_above_qual, other_qual, less_than_10km, x10km_and_over, works_mainly_from_home, employed, not_employed)

# Set constituency names as row names
local_area_data <- local_area_data %>% remove_rownames %>% column_to_rownames(var = "westminster_parliamentary_constituencies")

##### Data exploration

### Explore distribution of features to include

# Histograms of features: assess whether each feature has sufficient variance
hist(population_density$pop_density)
hist(age_distribution$aged_15_years_and_under)
hist(age_distribution$aged_16_to_64_years)
hist(age_distribution$aged_65_years_and_over)

# Pairwise and correlation plots: assess whether variables are highly correlated
pairs(local_area_data)
corrplot(cor(local_area_data), method = "number")
cor(local_area_data)

# Remove variables which have too little variance, are too highly correlated or are irrelevant
local_area_data <- local_area_data %>% select(-c(good_health))


##### Model building and evaluation

# Convert all features to same scale to prevent differences in weighting
local_area_data <- data.frame(scale(local_area_data))

# Adjust weighting of variables from the same factor
local_area_data <- local_area_data %>% mutate_at(vars("aged_15_years_and_under", "aged_16_to_64_years", "aged_65_years_and_over"), ~ . / (ncol(age_distribution) - 3)) 
local_area_data <- local_area_data %>% mutate_at(vars("no_qual", "level_1_qual", "level_2_qual", "level_3_qual", "level_4_or_above_qual", "other_qual"), ~ . / (ncol(education) - 3)) 
#local_area_data <- local_area_data %>% mutate_at(vars("good_health", "not_good_health"), ~ . / (ncol(health) - 3)) 
local_area_data <- local_area_data %>% mutate_at(vars("employed", "not_employed"), ~ . / (ncol(employment) - 3)) 
local_area_data <- local_area_data %>% mutate_at(vars("less_than_10km", "x10km_and_over"), ~ . / (ncol(distance_to_work) - 3)) 
#local_area_data <- local_area_data %>% mutate_at(vars("pop_density"), ~ . / (ncol(population_density) - 2)) 

# Set seed for reproducibility
set.seed(87473838)

# Visualise elbow plot to decide optimum number of clusters
fviz_nbclust(local_area_data, kmeans, method = "wss")
fviz_nbclust(local_area_data, kmeans, method = "silhouette")

# Build kmeans clustering model with optimum number of clusters
local_area_model <- kmeans(local_area_data, 5, nstart = 100)

# Assigned cluster for each local area
local_area_model$cluster

# Bar plot of cluster cardinality: size of each cluster
barplot(local_area_model$size)

# Mean of each feature for cluster
barplot(local_area_model$centers)

# Perform principal component analysis on dataset
pca <- prcomp(local_area_data, center = FALSE, scale = FALSE)

# View results of principal component analysis
summary(pca)

# Transform original dataset using PCA values
local_area_data_pca <- data.frame(predict(pca, local_area_data))

# Make PCA transformed data two-dimensional for easy visualisation
local_area_data_pca <- local_area_data_pca %>% select(PC1, PC2)

# Add cluster labels to datasets
local_area_clusters <- cbind(local_area_names, cluster = as.factor(local_area_model$cluster))
local_area_data_pca <- cbind(local_area_data_pca, cluster = as.factor(local_area_model$cluster))

# Visualise clusters in two-dimensions
ggplot(local_area_data_pca, aes(x = PC1, y = PC2, colour = cluster)) +
  geom_point()


##### Data presentation

# Load parliamentary constituencies shapefile
local_area_shapefile <- st_read("constituencies_shapefile/WPC_Dec_2018_GCB_GB.shp")

# Add cluster assignments to shapefile
local_area_shapefile_clusters <- left_join(local_area_clusters, local_area_shapefile, by = c("westminster_parliamentary_constituencies_code" = "pcon18cd"))

# Structure new file as shapefile
local_area_shapefile_clusters <- local_area_shapefile_clusters %>% st_as_sf()

# Set colour palette
palette <- c("#AA3377", "#CCBB44", "#AAAA00", "#4477AA", "#AA3377")

# Create map
tmap_mode("view")
tm_shape(local_area_shapefile_clusters) +
  tm_polygons("cluster", popup.vars = c("Constituency" = "westminster_parliamentary_constituencies"), palette = palette)
