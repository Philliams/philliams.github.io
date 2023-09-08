---
title: "Implementing Logistic regression in Python"
date: 2021-01-22T12:00:00Z
draft: false
tags: ["Python", "Machine Learning"]
# cover:
#     image: "/posts/logistic_regression/splash.jpg"
#     alt: "Books and knowledge"
ShowReadingTime: true
math: true
ShowCodeCopyButtons: true
---

One of the simplest Machine Learning algorithms is Logistic Regression. At a conceptual level, there’s not much more to it than some simple calculus, but this algorithm can still be pretty effective in a lot of situations. In this post, we’re going to take a little bit of a look at the math behind Logistic Regression and then implement our own Logistic Regression library in python.

## What is Logistic Regression?

First of all, when we talk about Machine Learning, we are really talking about curve fitting. What this means is that we have some numerical input data as well as the numerical output we want, we’ll then use that data to create a mathmatical model that can take in some input data and output the correct values.

In the case of Logistic Regression, we take in a vector of numerical values, and we get an output between 0 and 1. This is a specific type of Machine Learning classification. Basically, we want to know if something about the input data is true or false, with 1 corresponding to true and 0 corresponding to false.

Now that we’ve got that, what is Logistic Regression really? Logistic Regression is defined by two main equations:

$$ z = \sum w_i \cdot x_i $$
$$ y = \frac{1}{1+e^{-z}} $$

$x_i$​ is the ith element of our input vector, $w_i$ is the weight of that specific input and $z$ is the weighted sum of the $x$ and $w$ vectors. $y$ on the other hand, is the final output of the Logistic Regression equation and looks like this:

<iframe src="https://www.desmos.com/calculator/cyrjcwodjq?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0>
</iframe>

## Training a Linear Model

So now we have an idea of what our model looks like and how it is defined. The next step is to actually train the model by solving for the ww vector. Assuming we have a dataset of vectors xx (all of the same size) and values yy values that we want to predict, we want to find our weight vector ww that will maximize the accuracy of our model and give correct predictions.

The are several algorithms that can do this, each having their own pros and cons, such as Gradient Descent or Genetic Algorithms. However, we are going to train our Logistic Regression model using Linear Regression.

The linear model used in Linear Regression is given by the following equation:

$$ y = \sum b_i \cdot x_i $$

$b$ is our weight vector and can be obtained via Ordinary Least Squares:

$$ b = (X^{T}X)^{-1}(X^{T}Y) $$

When solving for $b$, $X$ is a 2D matrix, each row corresponds to a single input vector, $Y$ is a vector of the known outputs for the corresponding input in the $X$ matrix, $M^T$ and $M^{-1}$ are the matrix operations (for an arbitrary matrix $M$) of transpose and inversion respectively. We will not implement these matrix functions ourselves, but will instead use the built in NumPy functions for ease.

This should seem very similar, since it is exactly the same equation for $z$ in the Logistic Regression model, the only difference is that we pass the sum through a sigmoid transformation when performing Logistic Regression.

## Bridging Linear and Logistic Regression

This is where we can use a clever trick to transform the Logistic Regression problem into a Linear Regression problem. By applying the following function to the true/false (1/0) values of the classification, we can get equivalent values to train a Linear Regression model :

$$ y = \frac{1}{1+e^{-z}} $$
$$ z = ln(\frac{y}{1 - y}) $$

However, if we plug in the classification values of 0 and 1, we will get a domain error when calculating $z$, since we can’t divide by 0 or calculate the log of 0. To solve this, we can simply use values very close to 0 and 1 for our classification output, for example 0.001 and 0.999. This technique is called Label Smoothing.

So now, to train our Logistic Regression model, we take the classification output of 1 or 0, add some small constant to avoid numerical errors, train a Linear Regression model on the transformed data, then use the Linear Model and the Logistic function to make predictions on new data.

## Recap of the algorithm

Here is a recap of the algorithm to implement Logistic Regression, assuming you have a collection of numerical input vectors and the desired true/false output label:

1. Use label smoothing to convert each 0/1 label into 0.001/0.999 to avoid numerical issues.

2. Convert the smoothed labels into the linear domain using the following equation, where $y$ is the smoothed label and $z$ is the linear value by using: $z=ln(\frac{y}{1−y})$

3. Solve for the $b$ vector using: $ b = (X^{T}X)^{-1}(X^{T}Y) $, where the $Y$ vector is a list of the smoothed linear $z$ value

4. Use the weight vector $b$ and a new input vector $x$ to make a prediction using :
$$ z(x) = \sum x_i \cdot b_i $$
$$y(x) = \frac{1}{1 + e^{-z(x)}}$$

## Python Implementation

Now that all the of the theoretical equations have been established, we can actually implement our model and test it on some real world data. For this example, we will be using the [UCI ML Breast Cancer Wisconsin (Diagnostic) dataset](https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic). You can download a copy of the dataset directly, or you can import it through the [Scikit learn dataset module](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_breast_cancer.html). We are trying to predict if a tumor is bening or malignant with several features such as the radius, symmetry, smoothness and texture.

```Python
from sklearn.datasets import load_breast_cancer
import numpy
import math


# Define class to implement our logistic regression model
class LogisticRegression():

	def __init__(self, use_bias=False, smooth=1e-2, cutoff=0.5):
		# bias determines if we use a bias term or not
		self.use_bias = use_bias
		# instance variable for our weight vector
		self.weights = None
		# the cutoff is used to determine the prediction, if y(z) >= cutoff, y(z) = 1, else y(z) = 0
		self.cutoff = cutoff
		# the amount of smoothing used on the output labels
		self.smooth = smooth

	# will smooth all the labels given the Y vector
	def smooth_labels(self, Y):

		y_smooth = []
		for i in range(len(Y)):
			if Y[i] >= 1 - self.smooth:
				y_smooth += [1.0 - self.smooth]
			else:
				y_smooth += [self.smooth]

		return numpy.array(y_smooth)

	# calculates y given a single z
	def logistic_function(self, z):
		y = 1.0/(1.0 + math.exp(-z))
		return y

	# calculates z given a single y
	def inverse_logistic_function(self, y):
		z = math.log(y/(1-y))
		return z

	# convert the labels from 0/1 values to linear values
	def transform_labels_to_linear(self, Y):
		for i in range(len(Y)):
			Y[i] = self.inverse_logistic_function(Y[i])
		return Y

	# use the weights and a new vector to make a prediction
	def predict_on_vector(self, x):

		# calculate the weighted sum
		z = numpy.matmul(numpy.transpose(x), self.weights)

		prediction = self.logistic_function(z)

		if prediction >= self.cutoff:
			return 1
		else:
			return 0

	def predict(self, X):

		# using a bias will add a feature to each vector that is set to 1
		# this allows the model to learn a "default" value from this constant
		# the bias can be thought of as the offset, while the weights are the slopes
		if self.use_bias:
			ones = numpy.array([[1.0] for i in range(len(X))])
			X = numpy.append(ones, X, axis=1)

		# calculate the prediction for each vector
		predictions = []
		for i in range(len(X)):

			prediction = self.predict_on_vector(X[i])
			predictions += [prediction]

		return numpy.array(predictions)


	# train the model on the dataset
	def train(self, X, Y):

		# using a bias will add a feature to each vector that is set to 1
		# this allows the model to learn a "default" value from this constant
		# the bias can be thought of as the offset, while the weights are the slopes
		if self.use_bias:
			ones = numpy.array([[1.0] for i in range(len(X))])
			X = numpy.append(ones, X, axis=1)

		# smooth the labels
		Y = self.smooth_labels(Y)
		# convert labels to linear
		Z = self.transform_labels_to_linear(Y)
		# calculate weights
		self.weights = numpy.matmul(
				numpy.linalg.inv(
					numpy.matmul(
						numpy.transpose(X),
						X
					)
				),
				numpy.matmul(
					numpy.transpose(X),
					Y
				)
			)

# Apply the logistic regression model to the UCI ML Breast Cancer Wisconsin (Diagnostic) dataset
X, Y = load_breast_cancer(return_X_y=True)

#split the data into training and testing sets
X_test = X[:100]
X_train = X[100:]

Y_test = Y[:100]
Y_train = Y[100:]

# Initialize the model
model = LogisticRegression(use_bias=True)

# Train the model on the training set
model.train(X_train, Y_train)

# calculate the accuracy on the training set
predictions = model.predict(X_train)
print("Training Accuracy (%) = " + str(100 * numpy.sum(predictions == Y_train)/ float(len(Y_train))))

# calculate the accuracy on the testing set
predictions = model.predict(X_test)
print("Testing Accuracy (%) = " + str(100 * numpy.sum(predictions == Y_test)/ float(len(Y_test))))
```