# Clustering parliamentary constituencies with census data
by Dylan Atkinson

[Executive summary](-**Executive-summary**)

[Project findings](-**Project-findings**)

[Literature review](-**Literature-review**)

[Methodology](-**Methodology**)

[Project reflections and learnings](-**Project-reflections-and-learnings**)

[References](-**References**)

# **Executive summary**

This paper explains an approach to using k-means clustering to group local areas into similar categories using census data.

The model considers six themes: age, population density, health, education, economy and employment. Each was given equal weighting. Data across these themes was collected from 2021 census data for England and Wales. Each parliamentary constituency in England and Wales was assigned into one of five clusters based on these characteristics.

These clusters identify areas with similar social and economic characteristics across the country. These results could be used for a variety of purposes. These include identifying areas where government investment is most required, businesses selecting locations to expand their business or prospective home movers understanding more about the area they plan to move to.

This clustering framework could be built upon for more detailed analysis. This could include looking at more granular local areas, such as electoral wards. The number of clusters could be increased above five to understand localities in more detail.

# **Project findings**

The clustering project has found five clusters of parliamentary constituencies in England and Wales, using census 2021 data across six themes: age, population density, health, education, economy and employment. Each cluster has been named based on its characteristics.

| Cluster ID | Cluster name                       | Cluster features                                                                                                              |
|------------|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| 1          | University hubs                    | - Young population - Densely populated - Lives close to work - Good health                                                            |
| 2          | Economic core cities               | - Large working age population - Very densely populated - Good health - Very highly educated - Likely to work from home - High employment |
| 3          | Typical town and rural communities | - Elderly population - Sparesley populated - Works far from home - Low employment                                                     |
| 4          | Thriving commuter belt             | - Young population - Low population density - Good health - Highly educated - Likely to work from home - High employment                  |
| 5          | Struggling communities             | - Aging population - Low population density - Poor health - Low education - Unlikely to work from home - High unemployment                |

[![Interactive cluster map](/cluster_map_image.png)](https://dyl-atk.github.io/cluster_map.html)
[Click to interact with map](https://dyl-atk.github.io/cluster_map.html)

University hubs are densely populated areas with young and healthy populations. These are spread across the country in city centre and university locations. The high amount of students here means employment and education are low as these students do not yet have degrees or jobs.

Economic core cities are the rarest and most distinct cluster of local areas. These are very densely populated with a well educated, healthy, working age population. The population are likely to work from home and unlikely to work more than 10km from where they live. These are limited to entirely to central London and Bristol.

Typical town and rural communities are the most common cluster category. These are sparsely populated, with an aging population. Employment is low and people generally work far from where they live. These areas are spread across rural areas of England and Wales.

The thriving commuter belt has a low population density. The population is young, in good health and well educated. They are likely to work from home and employment rates are high. These areas surround London, covering parts of the South West, South East and Midlands.

Struggling communities have a low population density and their census indicators are linked with deprivation. They have an aging population, poor health and low levels of education. Unemployment rates are high and the population is unlikely to work from home.

# **Literature review**

## **Census data**

In March 2021, the Office for National Statistics conducted the census of England and Wales. The census is a mandatory survey for all households and is designed to build a picture of the country (Office for National Statistics, 2022). The census covers themes such as population, education, identity, housing, health and work. Data across these themes are already available via surveys based on samples. But the key benefit of a census is that it covers the entire population. David Norgrove (2018), Chair of the UK Statistics Authority, explains that “only the census provides consistent statistics for both small areas and small population groups” – the census unlocks a level of detailed analysis that would otherwise be impossible.

The 2021 census was launched following increased public awareness of privacy and data ethics. Wing (2019) identifies privacy and ethics as two key research challenge areas in the data science space. She explains the trade-off between having more data, which opens up opportunities to build better models, and the privacy concerns of pooling vast amounts of data. The census asks people highly sensitive questions: their health, living arrangements and even sexuality. Given that the census is a legal requirement, there are ethical concerns around how census data is stored and shared.

## **Machine learning**

Machine learning is a subset of artificial intelligence where computers are trained with data to solve problems (Brown, 2021). Deloitte (2020) found in their survey of business executives that 97% are using machine learning or plan to use it in the next year.

There are three main types of machine learning. In supervised learning, input data and desired outputs are fed into an algorithm. The algorithm learns from this labelled data and applies these rules when classifying unseen data. Reinforcement learning is where an algorithm is rewarded or punished based on desired behaviour. It is designed to select the optimum output from a set of outputs based on criteria. Finally, there is unsupervised learning, techniques that uncover patterns and insights without explicit human guidance (IBM, n.d.).

Census data is unique in that it is not a sample: the entire population is covered. This restricts the value of the most common supervised machine learning techniques – there is no unseen data to make predictions on. Unsupervised machine learning has the most value to add in extracting insights about the population of England and Wales from census data. A review of machine learning in urban studies found that supervised learning has overshadowed unsupervised learning so far (Wang and Biljecki, 2022). Despite this, the paper emphasised the benefits of unsupervised machine learning in this space: inferring patterns from massive urban studies datasets without requiring pre-determined labels or desired outputs.

## **K-means clustering**

Clustering is an unsupervised machine learning technique that groups similar objects (EMC Education Services, 2015). Clustering techniques observe patterns in the structure of data and use this to identify natural groupings.

k-means is a particular type of clustering, where datapoints are assigned to k clusters (Sharma, 2023). Firstly, k centroids are randomly placed. Datapoints are assigned to their closest centroid. Next the centroid for each cluster is re-initialised to the average of its datapoints. This begins an iterative process where the centroids are recalculated and datapoints reassigned to their closest cluster. These iterative steps optimise the model and are known as Expectation-Maximisation (EM). A key consideration when clustering is how distance between datapoints is measured. Whilst there are many options, Euclidean distance is the most common. Brownlee (2020) states this is the standard method for calculating distance between numerical values, like those in the census.

Rink (2021) discusses four mistakes made in clustering to avoid. These include a failure to do exploratory data analysis, not scaling features appropriately, building no representative clusters and not providing a description of cluster results. As clusters are assigned based on distance between datapoints and centroids, ensuring each variable in the model is on the same scale is critical. Converting values to a z-score is an approach to feature scaling. In this the z-score represents the number of standard deviations from the mean each value is (Frost, 2021). Davidson, Gourru and Ravi (2018) discuss the “cluster description problem” in their paper. The demand for explainable AI means names or descriptions for each cluster are essential to the model realising value. When k is small and the model features are simple, this can be completed manually. But they explain the challenges involved in automating this process, which is a barrier to communicating the results of large, complex clustering models.

There are many examples of clustering used to analyse population and census data. Vilella et al (2020) researched the link between socio-demographic attributes and news consumption. They used Chilean census data to cluster districts into five groups. They found clear correlations between news consumption patterns and socio-demographic groupings. The researchers pre-determined an appropriate range of values of k (between 3 and 8) and considered the optimum value within this range, looking at Gini values. This enabled them to avoid too few or many clusters – an inexplainable model, whilst still optimising the value of k. In another example, researchers estimated trajectories for urban neighbourhoods (Ling and Delmelle, 2016). They use clustering as a secondary part of their analysis to group neighbourhoods with similar trajectories. The clusters allowed them to assign, name and map similar neighbourhoods in US cities effectively and clearly, given the ability of the clusters to summarise complex data about each neighbourhood. But these researchers faced challenges including selecting a suitable value of k and missing data. K-means clustering is limited by missing data (Wagstaff, 2004).

## **Principal component analysis**

A greater emphasis is being placed on explainable AI. IBM regards explainable AI as “one of the key requirements for implementing responsible AI”. These are known as white-box models. Transparency about how models arrive at their conclusions can be critical. Ensuring models are interpretable and explainable builds trust, especially when these models are relied on for important decisions (Tannam, 2019). Clustering models that use many features are challenging to explain: visualisations showing more than two become complex for a non-technical audience to understand. This can make it difficult to share how a clustering algorithm has assigned its clusters. A solution to this is dimensionality reduction: condensing the clustering training dataset and then visualising this.

Principal Component Analysis (PCA) is a dimensionality reduction technique. It creates a set of new uncorrelated variables (Jolliffe and Cadima, 2016). These new variables condense the information contained within the original variables. Most of the original information can be preserved by taking a smaller number of these composite variables. PCA means that a large dataset used for clustering can be simplified, unlocking opportunities for easier communication and visualisation. By taking the first two principal components the clusters can be visualised in a 2-dimensional scatterplot (Kaloyanova, 2021). This is more understandable for a technical audience, but comes at the cost of some information loss from the dataset the clustering algorithm is trained on.

# **Methodology**

## **Choice of tools**

This clustering project is carried out using the open-source statistical programming language R. This allows the methodology to be reproducible and transparent. The full k-means clustering process can be carried out efficiently in R (Kumar, 2020). Additional packages are available for data processing, model building, model evaluation and data visualisation.

[Access the R code script for this project here](/Clustering%20local%20areas%20code.R)

## **Data source**

Data for this project comes from the 2021 census of England and Wales. This offers a rich source of social and economic data at a population level. Census data is available at highly granular levels. For this project, UK parliamentary constituencies have been chosen. These have the benefit of each being of a similar population size, ensuring each area in the model is comparable.

## **Model planning**

The k-means clustering model is trained using census data covering six key themes. These are age, population density, health, education, economy and employment. Within each theme are a set of variables included within the model. Weighting ensures each theme is given equal importance in the model. As without weighting the model would put greater emphasis on themes with more variables. Variables were selected from the 2021 census that best fit the six themes.

| Theme              | Variables                                                                                                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Age                | Aged 15 years and under (%) Aged 16 to 64 years (%) Aged 65 years and over (%)                                                                                 |
| Population density | Population density                                                                                                                                             |
| Health             | Good health (%) Not good health (%)                                                                                                                            |
| Education          | No qualifications (%) Level 1 qualification (%) Level 2 qualification (%) Level 3 qualification (%) Level 4 or above qualification (%) Other qualification (%) |
| Economy            | Works less than 10km from home (%) Works 10km and over from home (%) Works mainly from home (%)                                                                |
| Employment         | Employed (%) Not employed (%)                                                                                                                                  |

## **Data preparation**

The census data is downloaded from the ONS website in xlsx format. This is imported into the R Studio environment. The census data contains an observation for each parliamentary constituency for each variable. The imported data is then cleaned and processed: variable names are tidied and irrelevant columns are removed. The data is converted from counts into proportions: for example, the number of people employed is converted to an employment rate.

Next, the imported census data across all the themes are joined into a single dataframe. Initial checks are performed to ensure there are no duplicates or missing data.

## **Exploratory data analysis**

Exploratory data analysis is used to understand the model’s input data. Histograms are used to visualise the distribution of each variable: for a good clustering model, each variable should have a wide distribution indicating differentiation between local areas that the clustering algorithm can identify. The relationship between variables is explored using a scatterplot matrix and a plot of correlation coefficients. This allows multicollinearity, linear relationships between variables, to be detected (Shin, 2021). Clustering models are more robust to multicollinear inputs than other types of models. Census data by nature is often highly correlated: education, employment and health are strongly linked. Yet a suitable dataset for clustering will include variables with little correlation so there is differentiation to cluster. In this stage, variables with perfect correlation are dropped: good health is perfectly correlated with not good health so only good health is included in the model.

[Histograms](/local_area_hist.png)

[Scatterplot matrix](/local_area_pairs.png)

[Correlation plot](/local_area_corrplot.png)

## **Model building**

Next, the clustering algorithm is trained on the input data. A key consideration in k-means clustering is the value of k – the number of clusters. The optimum value of k minimises within sum of squares (total squared distance between datapoints and cluster centre) and maximises silhouette score (score of -1 to 1 indicating how well each datapoint fits its assigned cluster) (Banerji, 2021). The range of k was determined to be from 4 to 8 clusters. This restriction ensures that there are enough clusters to make meaningful inferences about the characteristics of local areas but not so many to overcomplicate the model. The optimum value of k will be the value between 4 and 8 that maximises silhouette score. Within sum of squares will always reduce for a higher value of k so the optimum point is the elbow of the curve – where the reduction in k given by taking the next highest k value slows (Anand, 2017). The model is built on the training data with k set as 5. This assigns each parliamentary constituency to one of five clusters.

[Within Sum of Squares plot](/wss_plot.png)

[Silhouette plot](/silhouette_plot.png)

## **Model evaluation**

The quality of the model’s outputs is then assessed. General clustering evaluation statistics are computed, including within sum of squares and silhouette score. The next step is to visualise the clusters to judge whether the k-means clustering algorithm has made sensible cluster assignments. PCA dimensionality reduction is used to reduce the number of variables in the training dataset (Utami, 2021). The first two principal components are taken so each local area can be visualised on a two-dimensional scatterplot (Singh, 2021). The clusters are shaded onto the scatterplot. The scatterplot shows the groups of datapoints identified as distinct clusters appear reasonable. 

![Alt text](/cluster_plot.png "")

Other metrics such as cluster cardinality show how many datapoints fall into each cluster (Google for Developers, n.d.). As cluster 2 is much smaller than other clusters, this requires further investigation in the data visualisation phase.

![Alt text](/cluster_sizes.png "")

## **Data visualisation**

The final stage is to communicate the outputs of the cluster models. This involves visualising the characteristics of each cluster using a bar chart. This allows inferences to be made as to the census characteristics each cluster features. This allows clusters to be given names so they are more meaningful to a non-technical audience.

![Alt text](/cluster_feature_plot.png "")

An interactive map shows which cluster each local area falls into. This allows the audience to identify the cluster a specific parliamentary constituency has been assigned into. It also allows spatial patterns to be identified. Cluster 2, the cluster with an unusually low cardinality represents central London, which has vastly different social and economic characteristics to the rest of the country so makes sense to be a distinct category.

# **Project reflections and learnings**

Hierarchical clustering / soft / fuzzy clustering?

# **References**

Anand, S. (2017) Finding Optimal Number of Clusters, R-bloggers. Available at: <https://www.r-bloggers.com/2017/02/finding-optimal-number-of-clusters/> [Accessed 6 July 2023]

Banerji, A. (2021) K-Mean \| K Means Clustering \| Methods To Find The Best Value Of K, Analytics Vidhya. Available at: <https://www.analyticsvidhya.com/blog/2021/05/k-mean-getting-the-optimal-number-of-clusters/> [Accessed 6 July 2023]

Brown, S (2021). Machine learning, explained, MIT Management Sloan School. Available at: <https://mitsloan.mit.edu/ideas-made-to-matter/machine-learning-explained> [Accessed 29 June 2023]

Brownlee, J (2020). 4 Distance Measures for Machine Learning, Machine Learning Mastery. Available at: <https://machinelearningmastery.com/distance-measures-for-machine-learning/> [Accessed 29 June 2023]

Davidson, Gourru and Ravi (2018). The Cluster Description Problem – Complexity Results, Formulations and Approximations, Advances in Neural Information Processing Systems 31. Available at <https://proceedings.neurips.cc/paper_files/paper/2018/file/3fd60983292458bf7dee75f12d5e9e05-Paper.pdf> [Accessed 29 June 2023]

Deloitte (2020). Becoming an AI-fuelled organisation, Deloitte Insights. Available at: <https://www2.deloitte.com/us/en/insights/focus/cognitive-technologies/state-of-ai-and-intelligent-automation-in-business-survey.html> [Accessed 29 June 2023]

EMC Education Services (2015). Data Science and Big Data Analytics.

Frost, J (2021). Z-score: Definition, Formula and Uses, Statistics By Jim. Available at: <https://statisticsbyjim.com/basics/z-score/>. [Accessed 29 June 2023]

Google for Developers (n.d.). Interpret Results and Adjust Clustering, Google for Developers. Available at: <https://developers.google.com/machine-learning/clustering/interpret> [Accessed 6 July 2023]

IBM (n.d. a). What is unsupervised learning? IBM. Available at: [https://www.ibm.com/topics/unsupervised-learning\#:\~:text=the%20next%20step-,What%20is%20unsupervised%20learning%3F,the%20need%20for%20human%20intervention](https://www.ibm.com/topics/unsupervised-learning#:~:text=the%20next%20step-,What%20is%20unsupervised%20learning%3F,the%20need%20for%20human%20intervention) [Accessed 29 June 2023]

IBM (n.d. b). What is explainable AI (XAI?), IBM. Available at <https://www.ibm.com/watson/explainable-ai> [Accessed 30 June 2023]

Jolliffe, I.T. and Cadima, J. (2016). Principal component analysis: a review and recent developments, Philosophical Transactions of the Royal Society A. Available at <https://doi.org/10.1098/rsta.2015.0202> [Accessed 30 June 2023]

Kaloyanova, E (2021). How to Combine PCA and K-means Clustering in Python, 365 DataScience. Available at <https://365datascience.com/tutorials/python-tutorials/pca-k-means/> [Accessed 30 June 2023]

Kumar, U. (2020). Clustering in R Programming, GeeksforGeeks. Available at: <https://www.geeksforgeeks.org/clustering-in-r-programming/> [Accessed 6 July 2023]

Ling, C. and Delmelle, E.C. (2016) ‘Classifying multidimensional trajectories of neighbourhood change: a self-organizing map andk-means approach’, Annals of GIS, pp. 1–14. Available at: <https://doi.org/10.1080/19475683.2016.1191545> [Accessed 30 June 2023]

Norgrove, D. (2018). Help Shape Our Future – The 2021 Census of Population and Housing in England and Wales. Available at: <https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/765089/Census2021WhitePaper.pdf> [Accessed 29 June 2023]

Office for National Statistics. (2022) About the census. Available at: <https://www.ons.gov.uk/census/aboutcensus/aboutthecensus> [Accessed 29 June 2023]

Rimon, M (2020). Understand 3 Key Types of Machine Learning, Gartner. Available at: <https://www.gartner.com/smarterwithgartner/understand-3-key-types-of-machine-learning> [Accessed 29 June 2023]

Rink, K (2021). Four mistakes in Clustering you should avoid, Towards Data Science. Available at <https://towardsdatascience.com/common-mistakes-in-cluster-analysis-and-how-to-avoid-them-eb960116d773> [Accessed 29 June 2023]

Sharma, N (2023). K-Means Clustering Explained, Neptune AI. Available at: <https://neptune.ai/blog/k-means-clustering> [Accessed 29 June 2023]

Shin, T. (2021) Understanding Multicollinearity and How to Detect it in Python, Medium. Available at: <https://towardsdatascience.com/everything-you-need-to-know-about-multicollinearity-2f21f082d6dc> [Accessed 6 July 2023]

Singh, S. (2022) K Means Clustering on High Dimensional Data., The Startup. Available at: <https://medium.com/swlh/k-means-clustering-on-high-dimensional-data-d2151e1a4240> [Accessed 6 July 2023]

Tannam, E. (2019). What are the benefits of white-box models in machine learning? [online] Silicon Republic. Available at: https://www.siliconrepublic.com/enterprise/white-box-machine-learning\#:\~:text=White%2Dbox%20models%20help%20organisations [Accessed 30 Jun 2023].

Utami, Z.D. (2021) Implementation of Principal Component Analysis (PCA) on K-Means Clustering in R, Medium. Available at: <https://medium.com/@zullinira23/implementation-of-principal-component-analysis-pca-on-k-means-clustering-in-r-794f03ec15f> [Accessed 6 July 2023]

Vilella et al (2020). News and the city: understanding online press consumption patterns through mobile data. EPJ Data Science. Available at <https://doi.org/10.1140/epjds/s13688-020-00228-9> [Accessed 29 June 2023]

Wagstaff, K. (2004) ‘Clustering with Missing Values: No Imputation Required’, Classification, Clustering, and Data Mining Applications, pp. 649–658. Available at: <https://doi.org/10.1007/978-3-642-17103-1_61> [Accessed 30 June 2023]

Wang, J and Biljecki F (2022). Unsupervised machine learning in urban studies: A systematic review of applications, Cities. Available at: <https://doi.org/10.1016/j.cities.2022.103925> [Accessed 29 June 2023]

Wing, J (2019). Ten Research Challenge Areas in Data Science, Columbia University Data Science Institute. Available at: <https://datascience.columbia.edu/news/2019/ten-research-challenge-areas-in-data-science/> [Accessed 29 June 2023]
