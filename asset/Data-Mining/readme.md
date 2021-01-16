### Introduction

The human face is a carrier with numerous potential information. It is possible to obtain the individual skills of cognitive and the capability of attention by detecting the position of facial key points that can predict the performance of driver when the technique of facial recognition is integrated with drivers’ head pose estimation. The application of data mining techniques in human facial detection is a significant branch of machine learning domain. Cluster analysis, which is considered as a tool of unsupervised learning and can be achieved by distinct algorithms according to satisfy different requirements for constitutes a cluster. The primary function of this tool is to assort finite sets of objects into various classes, which followed the principle that similar objects are grouped in one cluster. For the pattern recognition based on human face, it can be divided into two main categories which include feature-based and holistic-based. In this paper, a dataset (Katerine, Aura and Antonio, 2016) contains four facial key points (face, eyes, nose and mouth), as well as the annotation of the face bounding box, is used in cluster analysis in order to distinguish the different part of the human face. several algorithms consist of K-Means, Density-Based Spatial Clustering of Applications with Noise (DBSCAN) and Expectation–Maximization (EM) representing centroid models, density models and distribution models of cluster respectively are tested to explore the performance of clustering approaches and geometrical relationships between various facial key points, and the most effective algorithm will be acquired by some metrics for evaluating such as Dunn index (DI) and cluster Silhouette measures. Through detecting the individual facial characterization, it is available to provide particular benefits to evaluate the driving status in real-time and decrease the traffic accident rate correspondingly.

The remainder of this paper is established in four sections. In the first section, it will introduce an overview of the clustering application domain and the purpose of this case initially. Section 2 details the implemented experiments include the description of dataset and appropriate schemes based on three mentioned algorithms. Additionally, the process of data pre-processing and feature selection, parameter tuning as well as performance metric are discussed in this section, and giving an analytical comparison between various clustering algorithms finally. Section 3 explains the results, selects a ‘winner’ based on performance and compare with the previous significant case study.

### Background
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
# K-Means
K-means algorithm is a widely used clustering algorithm for carrying out unsupervised learning tasks based on similarity analytics. It classifies relatively similar samples into the same category by comparing the similarity between samples (Ding & He, 2004).

The main principle of K-Means algorithm is simple that it focuses on the clustering to group a training dataset X = 𝑥%, 𝑥', ... , 𝑥) as ‘n’ observations into k clusters C = {𝐶%,𝐶',...,𝐶-}, and each observation sets in the cluster based on the nearest centroid (mean) which are treated as a prototype of the cluster. It calculates the distance between each sample 𝑥/ and the centroid through the squared the Euclidean distances measurement. Afterwards, the sample will be divided into the category which has the nearer centroid and the centroid will be recalculated in the meanwhile, subsequently, repeating the above process until the centroid tends to be optimal. This process is
equivalent to solve the following formulation:
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img1.png)
where 𝜇/ is the mean of centroid in 𝐶/ . The convergence speed of the K-Means algorithm is slower on large-scale datasets since the similarity between sample and centroid require to be calculated in every iteration. Although K-Means is one of the most efficient clustering algorithms and the performance is considered when the cluster approximates a Gaussian distribution, it is not appropriate for some particular situations.
