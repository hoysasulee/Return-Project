import pandas as pd
import numpy as np
from bokeh.plotting import figure, show, vplot, hplot
from bokeh.io import output_notebook; output_notebook()

import mixem

data = pd.read_csv("linear.csv")
data = data.iloc[:,1:3]
print(data.head())

weights, distributions, ll = mixem.em(np.array(data), [
    mixem.distribution.MultivariateNormalDistribution(np.array((2, 50)), np.identity(2)),
    mixem.distribution.MultivariateNormalDistribution(np.array((4, 80)), np.identity(2)),
])

N = 100
x = np.linspace(np.min(data.xF0), np.max(data.xF0), num=N)
y = np.linspace(np.min(data.yF0), np.max(data.yF0), num=N)
xx, yy = np.meshgrid(x, y, indexing="ij")

# Convert meshgrid into a ((N*N), 2) array of coordinates
xxyy = np.array([xx.flatten(), yy.flatten()]).T

# Compute model probabilities
p = mixem.probability(xxyy, weights, distributions).reshape((N, N))

fig2 = figure(title="Fitted Old Faithful Data", x_axis_label="Eruption duration (minutes)", y_axis_label="yF0 time (minutes)")

# Plot the grid of model probabilities -- attention: bokeh expects _transposed_ input matrix!
fig2.image(image=[p.T], x=np.min(data.xF0), y=np.min(data.yF0), dw=np.ptp(data.xF0), dh=np.ptp(data.yF0), palette="Spectral11")

# Plot data points
fig2.scatter(x=data.xF0, y=data.yF0, color="#000000")

show(fig2);