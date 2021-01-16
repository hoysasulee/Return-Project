import pandas as pd
import sklearn
from sklearn import preprocessing as per
from sklearn.preprocessing import Normalizer

dataset=pd.read_csv("distance.csv", sep=',')
normalizeData = dataset.iloc[:,3:5]
scaler = Normalizer().fit(dataset)
normalizeData = scaler.transform(dataset)
normalizeData = pd.DataFrame(normalizeData, index=dataset.index, columns = dataset.columns)

print(normalizeData,file=open("output.txt", "a"))

