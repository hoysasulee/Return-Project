# Introduction

The human face is a carrier with numerous potential information. It is possible to obtain the individual skills of cognitive and the capability of attention by detecting the position of facial key points that can predict the performance of driver when the technique of facial recognition is integrated with drivers’ head pose estimation. The application of data mining techniques in human facial detection is a significant branch of machine learning domain. Cluster analysis, which is considered as a tool of unsupervised learning and can be achieved by distinct algorithms according to satisfy different requirements for constitutes a cluster. The primary function of this tool is to assort finite sets of objects into various classes, which followed the principle that similar objects are grouped in one cluster. For the pattern recognition based on human face, it can be divided into two main categories which include feature-based and holistic-based. In this paper, a dataset (Katerine, Aura and Antonio, 2016) contains four facial key points (face, eyes, nose and mouth), as well as the annotation of the face bounding box, is used in cluster analysis in order to distinguish the different part of the human face. several algorithms consist of K-Means, Density-Based Spatial Clustering of Applications with Noise (DBSCAN) and Expectation–Maximization (EM) representing centroid models, density models and distribution models of cluster respectively are tested to explore the performance of clustering approaches and geometrical relationships between various facial key points, and the most effective algorithm will be acquired by some metrics for evaluating such as Dunn index (DI) and cluster Silhouette measures. Through detecting the individual facial characterization, it is available to provide particular benefits to evaluate the driving status in real-time and decrease the traffic accident rate correspondingly.

The remainder of this paper is established in four sections. In the first section, it will introduce an overview of the clustering application domain and the purpose of this case initially. Section 2 details the implemented experiments include the description of dataset and appropriate schemes based on three mentioned algorithms. Additionally, the process of data pre-processing and feature selection, parameter tuning as well as performance metric are discussed in this section, and giving an analytical comparison between various clustering algorithms finally. Section 3 explains the results, selects a ‘winner’ based on performance and compare with the previous significant case study.

# Background
Details in terms of the application domain associated with this data mining cluster experiment will be described in the following section, as well as a relevant statement with regard to the purpose of the analysis.

## Application domain
Unsupervised learning is one of the most significant categories of machine learning. The main application of unsupervised learning algorithms consists of cluster analysis, association rule and dimensionality reduce. The used dataset aims to seek potential disciplines from the value of each instance by certain unsupervised learning algorithms in order to access the recognition of individual facial features.
There are several underlying conditions to implement the experiment as cluster analysis. Firstly, the dataset has no pre-existing labels that unable to adopt a supervised learning method to deal with this problem. In addition, cluster analysis enables to achieve the classification which determined by multiple variables. The expression of human face in this paper was presented by the numeric dataset and was evaluated by several facial vectors. Besides this, cluster analysis is also an exploratory data mining task that efficiently analyzes the intrinsic characteristics and groups things based on the principle of similarity. It is a commonly used technique in data mining.

## Purpose of research
The purpose of this research is to evaluate the performance of various clustering algorithms through feasible validation method. The validation of clustering outcome is quite tricky. The universal evaluation of this task is divided as internal-based, external- based and manual-based. Each evaluation has its advantages and weaknesses refer to the following explanation.

In internal-based evaluation, the performance of clustering is measured without prior information in terms of the distribution based on the original data, and the internal clustering data are summarized to a certain quality score to seek the internal structure and distribution state of the dataset. It is a conventional method to find the optimal cluster of the dataset. However, the problem that high-quality scores do not represent high performances may exist in this criterion.

In contrast, the external evaluation assesses the clustering performance by comparing the suitability between the results and the real data distribution, which is not used for clustering. These data usually contain classification labels and created by manual.

In this paper, we have no extra labelled data can be utilized to test the clustering performance externally. Therefore, we decided to use two internal-based metric methods involve Dunn Index (DI) and Silhouette coefficient to evaluate the performance of clustering.

### Experiment Study
This section will include the whole process of cluster analysis experiment. In the dataset description chapter, it will present details of the raw data used in the experiment and methods which are contributed to pre-processing these data will be discussed later in the next pre-processing chapter. Subsequently, the data mining algorithms will be interpreted in mining schemes section together with the examination of its strengths and limitations. After pre-processing chapter is feature selection, parameter tuning and performance metric, the performance metric will be emphasized among them because it is defined to include a variety of factors which is associated with the promotion of the model accuracy. Finally, the chapter experimental setups will compare various algorithms as an analytical basis to evaluate the performance of models, outcomes expressed in visualization that will be depicted as supporting evidence.

## Dataset Description
The annotation face dataset used in this paper represents the basic situation of driver face images in a table format, which is originally created in Katerine, Aura and Antonio (2016, p. 98-107). The size of the raw data sample is 606 and each column have specific numeric values for a facial key position. All instances are randomly distorted and organized without labels concerning the gaze direction which facial pattern faced toward. Thus, the gaze directions of the actual situation based on facial positions are considered as frontal direction. The attributes of facial key position are derived by 14 columns, from first to fourteenth (except the filename and imgnum attribute) respectively are:
- The x-coordinate of the center point of face. 
- The y-coordinate of the center point of face. 
- The width of face.
- The height of face.
- The x-coordinate of the center point of right eye. 
- The y-coordinate of the center point of right eye. 
- The x-coordinate of the center point of left eye. 
- The y-coordinate of the center point of left eye. 
- The x-coordinate of the center point of nose.
- The y-coordinate of the center point of nose.
- The x-coordinate of the center point of right mouth. 
- The y-coordinate of the center point of right mouth. 
- The x-coordinate of the center point of left mouth. 
- The y-coordinate of the center point of left mouth.

## Mining Schemes
### K-Means
K-means algorithm is a widely used clustering algorithm for carrying out unsupervised learning tasks based on similarity analytics. It classifies relatively similar samples into the same category by comparing the similarity between samples (Ding & He, 2004).

The main principle of K-Means algorithm is simple that it focuses on the clustering to group a training dataset X = 𝑥%, 𝑥', ... , 𝑥) as ‘n’ observations into k clusters C = {𝐶%,𝐶',...,𝐶-}, and each observation sets in the cluster based on the nearest centroid (mean) which are treated as a prototype of the cluster. It calculates the distance between each sample 𝑥/ and the centroid through the squared the Euclidean distances measurement. Afterwards, the sample will be divided into the category which has the nearer centroid and the centroid will be recalculated in the meanwhile, subsequently, repeating the above process until the centroid tends to be optimal. This process is
equivalent to solve the following formulation:
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img1.png)

where 𝜇/ is the mean of centroid in 𝐶/ . The convergence speed of the K-Means algorithm is slower on large-scale datasets since the similarity between sample and centroid require to be calculated in every iteration. Although K-Means is one of the most efficient clustering algorithms and the performance is considered when the cluster approximates a Gaussian distribution, it is not appropriate for some particular situations.

Typically, the K-Means algorithm is not suitable for seeking clusters with non- convex shapes or clusters with large differences in size refer to the Mouse dataset (Chire, 2010) as an example of this limitation showed in Figure 1. Even if the clusters are convex (spherical in this case) K-Means is unable to obtain the clusters correctly due to the crucial erroneous assumptions.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img2.png)

### DBSCAN
Density-Based Spatial Clustering of Applications with Noise (DBSCAN) is an algorithm based on density clustering. It is designed to detect high-density regions that are separated from low-density regions.

The estimation for the density of a specific point in the dataset is required when applying the DBSCAN algorithm. The density of a specific point is obtained by calculating the number of data points at a designated radius that the result is also called local density. The specific point can be divided in 3 class by the clustering based on different density, which are the core point (the density is higher than certain threshold), the edge point (the density is lower than certain threshold but set on the field of the core point) and the noise point (neither the core point nor the edge point). DBSCAN does not require to determine the number of clusters, therefore, the convergence efficiency is faster than K-means. However, a case study employed DBSCAN for swallowing vibration segmentation and suffered a complex obstacle that large differences presence in terms of the density of the points in feature space (Dudik et al., 2015).

### EM
The Expectation-Maximization (EM) is an algorithm which is commonly used for the maximum likelihood estimation and the maximum a posterior estimation of a probabilistic model with unobserved latent variables. The EM algorithm is usually correlated with The Gaussian Mixture Models (GMM) to goal the clustering purpose which is also the method used in this paper. However, it is no guarantee to support that the EM algorithm can obtain the global best solution while it is able to improve the result in each clustering step. An exemplary example shows that a K-Means clustering model based on the EM missed the global optimum in Figure 2 (Michael, 2017). It led to the center of the yellow cluster migrating in between the two top blobs, essentially combining them into one.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img3.png)

## Pre-processing
### Linear Regression
Considering possible differences presence in drivers’ faces and pattern sizes, Linear Regression method is required to make the center points of the drivers’ face coincide to each other for 606 instances. The width values and the height values are transformed to a uniform value and using the zoom coefficients as weights to standardize the coordinate of facial key points. Formally, the mathematical formulation of this regression model can be indicated as follows:
<img src="http://chart.googleapis.com/chart?cht=tx&chl= Y ={W_i}*X+{b_i}" style="border:none;">
                                                                                             
The variable Y is the objective position of facial key points, 𝑤/ is the 𝑖th zoom coefficient, the variable X is the vector of the original position and 𝑏/ is the 𝑖th bias. In this paper, the zoom coefficients are given by the maximum of the face width and the
face height.

### Normalization
In order to obtain better clustering performance, the normalization method is necessary to normalize the modified data in the range of [0,1] .

### Feature Selection
hanks to the complexity of the relevance between various face patterns. The implementation of feature selection process, which represents extreme significance for the improvement of the experiment performance. The normalized original facial coordinates are considered as the object of clustering initially. In addition, the Euclidean distances are calculated as a series of geometric features in order to explore more extend manifestation from the dataset, which showed in Figure 3. The point RE represents the right eye position and N is the nose position, the distance between these two facial keypoints can be computed by known coordinates and vertical lines. The same can be proved in other facial keypoints’ position.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img4.png)

Moreover, Principal Component Analysis (PCA), the schema aim at resulting in the smallest error between the attribute vector and its projections by seeking a linear subspace in data space, also used in this task to simplify the dataset and maintain the variance which contributed the most in the dataset by reducing the dimensionality to 2.
It has capability to create benefits for the visualized clustering result.

## Performance Metric
### Dunn Index
Dunn Index (DI), an internal validity index for clustering evaluation through identifying compact sets of clusters, is used as a performance metric in this paper. The outcome of this method is based on the clustered data itself. The following formulation illustrates the mathematical calculation process of DI. It is usually considered that the higher DI the better clustering performance the model has, despite the computational cost may increase due to the growth of dimensionality and clusters’ amount.

### Silhouette coefficient
Silhouette coefficient integrates the Cohesion and Separation of clustering method and is used to evaluate the performance of clustering. The value of Silhouette coefficient is between -1 and 1. Theoretically, the closer the value to 1, the better clustering effect it has. Initially, it requires to calculate the dissimilarity in the same cluster and any other cluster respectively. Then, the Silhouette coefficient can be defined as Figure 4.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img5.png)

The mean of 𝑠 𝑖 of all samples is called the Silhouette coefficient of the clustering result, which is a reasonable and effective measure of the cluster.

# Results
## Empirical Analysis
### K-Means
Initially, the Elbow method is used to determine the appropriate number of clusters which are partitioned by the K-Means algorithm. Each iteration of clustering is plotted in Figure 5 after Linear Regression process and select the number that represents the most variance. From the graph, the elbow appears between 2 and 4 that avoiding diminishing returns of adding more clusters. Therefore, we select 3 as the number of clusters.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img6.png)

The dataset was tested depend on 4 situations respectively consist of the row data, the regression data, the normalized data and the Euclidean distances. Figure 6 demonstrates the visualized clustering result in terms of K-Means with K=3 and the random number for centroid initialization is 1.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img7.png)

It can be observed that the effect of clustering was promoted through various optimizations, the Linear Regression is the most effective particularly among them, for the model. In the same way, even we set the number of cluster K to 4, the performance of K-Means algorithm also worked in a reasonable range and the dataset was splitted into 4 distinct clusters. Table 1 shows the number of observations in each cluster with PCA, and compare with the amount without PCA.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img8.png)

Subsequently, cluster silhouettes were also plotted which can be seen in Figure 7 to visualize outliers and measure the performance of this model.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img9.png)

### DBSCAN
The DBSCAN model was placed on a high expectation before the experiment because of the merit it is to achieve clustering based on density. However, the truth is not ideal. Through tuning two main parameters include the maximum distance between two samples (eps) and the number of core point, the dataset is distributed in several clusters in Figure 8. There were a large number of noises which cannot be clustered arise in the output, and the number of clusters did not fit the expectation that it should be.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img10.png)

Consider the Silhouette coefficient shows in Figure 9, more than a half data were given a negative value of silhouette coefficient that represented as noises in the
clustering result. It implied that this model did not fit the dataset.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img11.png)

Although the performance of DBSCAN algorithm is not satisfactory, the performance evolution still can be noticed compare with the raw data and the data after pre-processing and feature selection.

### EM
The GMM is used to clustering the data due to its strong correlation with EM algorithm. Through tuning the parameter which the number of mixture components and the maximum iterations (n_components = 2, max_iter=100), it produced the result refer to Figure 10.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img12.png)

From this graph, it can be proved that the performance of data clustering was improved by a suitable process for the dataset. Typically, the normalized data seems extremely fitting for the EM algorithm. In contrast, the Euclidean distance represented worsening.

## Comparison
The dataset was established in 2016 that it is not the first time for it to implement a clustering analysis. The research based on this dataset was originated from the study indicated by Katerine, Aura and Antonio (2016). It provides numerous valuable experience for the paper which aims at similar dataset analytics. In this case, they created a reduced feature model with regard to driver head pose estimation. Fisher’s Linear Discriminant (FLD), PCA and multiple linear regression was used for each pose interval. It supposed two reliable method aim at two different datasets. The best accuracy of these methods are 100% for manual detection and 98.85% for automatic one which is able to be combined in a tablet or a real-time mobile application due to the low computational cost.
Antonopoulos, Nikolaidis and Pitas (2007) supposed a Hierarchical method for facial attributes clustering and utilized the Scale Invariant Feature Transform (SIFT) algorithm to calculate the dissimilarity matrix, 941 face images were clustered in 4 clusters with 0.8763 F-measure (1 indicating perfect clustering).

## Discussion
Consider the Silhouette coefficient produced from each algorithm and its efficiency. It is not hard to evaluate the most effective algorithm, which is K-Means. It represented a high distinction of each cluster with numerous parameter tuning integrations and satisfied in four situations set before the experiment. While the DBSCAN algorithm fit the dataset worst together with a large number of noise and low accuracy of distinction. Although the EM algorithm showed highly effective for the normalized data, the performance in the Euclidean distance did not satisfy the requirement of the experiment.

# Conclusion
This paper achieved a clustering analysis for a facial attributes dataset (Katerine, Aura and Antonio, 2016). The method Linear Regression and Normalization were used in data pre-processing and the Euclidean distance was calculated to obtain more effective feature for the model as well as PCA.
For the mining schema, the algorithms K-Means, DBSCAN and EM were used to implement clustering analysis respectively. Consequently, the clustering result was measured by Dunn Index and Silhouette coefficient method to evaluate the performance of each algorithm. In conclusion, the output showed that K-Means is the best algorithm in three to fit the annotation face dataset. It could produce 3 or 4 clusters with high accuracy and low cost of time.

# Reference
[1]. Antonopoulos, P., Nikolaidis, N., & Pitas, I. (2007). Hierarchical Face Clustering using SIFT Image Features. 2007 IEEE Symposium on Computational Intelligence in Image and Signal Processing.
[2]. Bansal, A., Nanduri, A., Castillo, C. D., Ranjan, R., & Chellappa, R. (2017). UMDFaces: An annotated face dataset for training deep networks. 2017 IEEE International Joint Conference on Biometrics (IJCB).
[3]. Diaz-Chito, K., Hernández-Sabaté, A., & López, A. M. (2016). A reduced feature set for driver head pose estimation. Applied Soft Computing, 45, 98–107.
[4]. Ding, C., & He, X. (2004). K-means clustering via principal component analysis.
Twenty-First International Conference on Machine Learning - ICML ’04.
[5]. Dudik, J. M., Kurosu, A., Coyle, J. L., & Sejdić, E. (2015). A comparative analysis of DBSCAN, K-means, and quadratic variation algorithms for automatic identification of swallows from swallowing accelerometry signals. Computers in Biology and Medicine, 59, 10–18.
[6]. Michael, B. (2017). Machine Learning for OpenCV. Packt Publishing.

