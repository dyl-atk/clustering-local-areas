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
local_area_data <- full_join(age_distribution, population_density, by = "westminster_parliamentary_constituencies_code")

# Remove .x at end of constituency name attribute
local_area_data <- local_area_data %>% rename(westminster_parliamentary_constituencies = westminster_parliamentary_constituencies.x)

# Check there is no missing data following join (desired result is 0 for each attribute)
local_area_data %>% map(~ sum(is.na(.)))

# Check there is one row per constituency. There should be 573 constituencies in England and Wales
nrow(local_area_data)

# Create data frame of constituency names and codes
local_area_names <- local_area_data %>% select(westminster_parliamentary_constituencies_code, westminster_parliamentary_constituencies)

# Select only useful columns for clustering model
local_area_data <- local_area_data %>% select(westminster_parliamentary_constituencies, aged_15_years_and_under, aged_16_to_64_years, aged_65_years_and_over, population_density)

# Set constituency names as row names
local_area_data <- local_area_data %>% remove_rownames %>% column_to_rownames(var = "westminster_parliamentary_constituencies")



##### Data exploration

### Explore distribution of features to include

# Histograms of features: assess whether each feature has sufficient variance
hist(population_density$population_density)
hist(age_distribution$aged_15_years_and_under)
hist(age_distribution$aged_16_to_64_years)
hist(age_distribution$aged_65_years_and_over)

# Pairwise and correlation plots: assess whether variables are highly correlated
pairs(local_area_data)
corrplot(cor(local_area_data))
cor(local_area_data)

# Remove variables which have too little variance, are too highly correlated or are irrelevant
local_area_data <- local_area_data %>% select(-aged_16_to_64_years)


##### Model building

# Convert all features to same scale to prevent differences in weighting
local_area_data <- data.frame(scale(local_area_data))

# Visualise elbow plot to decide optimum number of clusters
fviz_nbclust(local_area_data, kmeans, method = "wss")

# Build kmeans clustering model with optimum number of clusters
local_area_model <- kmeans(local_area_data, 3, nstart = 50)

# Assigned cluster for each local area
local_area_model$cluster

# Size of each cluster
local_area_model$size

# Mean of each feature for cluster
local_area_model$centers

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


##### Model evaluation

##### Data visualisation

# Load parliamentary constituencies shapefile
local_area_shapefile <- st_read("constituencies_shapefile/WPC_Dec_2018_GCB_GB.shp")

# Add cluster assignments to shapefile
local_area_shapefile_clusters <- left_join(local_area_clusters, local_area_shapefile, by = c("westminster_parliamentary_constituencies_code" = "pcon18cd"))

# Structure new file as shapefile
local_area_shapefile_clusters <- local_area_shapefile_clusters %>% st_as_sf()

# Create map
tmap_mode("view")
tm_shape(local_area_shapefile_clusters) +
  tm_polygons("cluster", popup.vars = c("Constituency" = "westminster_parliamentary_constituencies"))
