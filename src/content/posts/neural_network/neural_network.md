---
title: "Implementing Neural Networks in Python"
date: 2021-01-23T12:00:00Z
draft: false
tags: ["Python", "Machine Learning"]
ShowReadingTime: true
math: true
ShowCodeCopyButtons: true
---

One of the more interesting Machine Learning models is the Neural Network. A Neural Network is a highly non-linear mathematical model that can be fitted to very complicated datasets, from image classification to text translation. In this blog post, we’ll be implementing our own simple Neural Network library in python, then test how our model performs through a practical example on an image classification dataset.

## What is a Neural Network?

There are several types of Neural Networks, however we will be examining the simplest variant : a simple Feed-Forward Neural Network. In a Feed-Forward Neural Network, there are 3 main components :

1. Neurons
2. Activation Functions
3. Layers

A neuron is a simple non-linear entity, it can be defined by the two following equations :

$$ z = b + \sum x_i \cdot w_i $$

$$ y = f(z) $$

In this notation, the $x_i$ value indicates the ith value of the input vector $x$, while the $w_i$ value is the ith value of the weight vector $w$. The $b$ term is called the bias and and allows the neuron to model an offset, while the weights allow the neuron to model how quickly the output should change in response to a change in the inputs. Finally, the $f(z)$ function is an arbitrary non-linear function typically chosen from a catalogue of standard functions.

## Activation Functions

The output of the neuron is defined as some function $f(z)$ of the weighted sum, but what is is it? $f(z)$ is called the activation function and can be chosen from a selection of commonly used functions (or you can implement your own custom function as long as it is continuous and differentiable). Some common activations functions are the Sigmoid function (also called logistic function), the Hyperbolic Tangent function or the Rectifier function (also called ReLu).

The Sigmoid function is given by:

$$ f(z) = \frac{1}{1+e^{-z}} $$

<iframe src="https://www.desmos.com/calculator/3xmoswokp1?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>

The Hyperbolic Tangent function is defined as follows :

$$ f(z) = \frac{e^{2z} - 1}{e^{2z} + 1} $$

<iframe src="https://www.desmos.com/calculator/mvvxv4jcjp?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>

The Rectifier function (ReLu) is given as follows:

$$ f(z) = max(z, 0) $$

<iframe src="https://www.desmos.com/calculator/n2jbzumgki?embed" width="500" height="500" style="border: 1px solid #ccc" frameborder=0></iframe>

An interesting fact about the Rectifier Function is that the derivative is not defined at 0, since the function is piecewise, however in practice we can simply decide what side of the piecewise function to use when calculating the derivative.

Now that we have the defining equations for the neurons and the activation functions, we can arrange the neurons into layers to form an actual Neural Network. A Neural Network can be made up of a single neuron or thousands of them, but typically conforms to the following architecture :

![Neural Network Architecture](/posts/neural_network/neural_network.svg)

In the diagram above, the input layer represents the raw numerical input vector, each circle in the input layer represents a single input dimension, so if there is 16 circles in the input layer, we can imagine that the neural network will receive a vector of 16 values as input. We call these input values features.

The lines represent the connections between the neurons, so if there is a line between two neurons, the output of the neuron on the left will be taken as an input to the neuron on the right.

For the hidden and output layers, each circle represents a single neuron, and as you can see, all the outputs from one layer are fed in as inputs to all the neurons in the next layer.

The number of layers, and the number of neurons in each layer is determined experimentally or inspired by heuristics, however the input and output layer sizes are usually determined by the available data. For example, you may try to predict a set of 3 values based on an input vector with 32 features.

With the structure of the Neural Network defined, and the functions within the neurons given, we can establish how to actually solve for the weights that will give the best performance.

## Gradient Descent and Backpropagation

There are two algorithms commonly used to solve for the weights of a neural network: Gradient Descent and Backpropagation. First let’s look at the output neurons of the network.

To understand Gradient Descent, we need to choose a cost function $C$ (also called error $E$). This cost function should decrease as performance gets better, this way we can frame the problem of training a Neural Network as optimizing the weights of each neuron in the network to minimize the cost (or error) of the network on some training data. For our network we will be using the mean squared error (MSE), which is defined as follows :

$$ E = \frac{1}{2}(y - \hat{y})^2 $$

The further away we are from the right answer, the larger our error $E$ is. Note that $y$ is the true value for a given data point and $\hat{y}$​ is the output of our model for that same input. We can now find the derivative of the error with regard to the model output, so that we can figure out how the error changes with the output of the model:

$$ \frac{\partial E}{\partial \hat{y}} = y - \hat{y}$$

But we what we really want to know is how the cost changes with a change in the weights, since that would allow us to optimize the weights directly. The first step is to go one step further with our derivative (using the chain rule) and find how $E$ changes with the $z$ value of the output neuron:

$$ \frac{\partial E}{\partial z} = \frac{\partial E}{\partial \hat{y}} \cdot \frac{\partial \hat{y}}{\partial z} $$

Finally, we can go one step further and derive the error such that we get the derivative of the error relative to the weight of the output neuron:

$$ \frac{\partial E}{\partial w_i} = \frac{\partial E}{\partial \hat{y}} \cdot \frac{\partial \hat{y}}{\partial z} \cdot \frac{\partial z}{\partial w_i} $$

But from earlier, we know that $\hat{y}=f(z)$ and $ z = b +\sum w_i \cdot x_i $​, so we by replacing the partial derivatives in the previous equation, we can get the actual derivative of the error relative to the weights and bias:

$$ \frac{\partial E}{\partial w_i} = (y - \hat{y}) \cdot f'(z) \cdot x_i$$
$$ \frac{\partial E}{\partial b} = (y - \hat{y}) \cdot f'(z) $$

So now that we have the derivative, what do we do? Here, we apply Gradient Descent. Basically, using the derivative we can figure out if an increase or a decrease of the value of the weight will decrease the cost, then we iteratively update the weights to minimize the weight. $\eta$ is called the "Learning Rate" and is a constant chosen to adjust the size of the iteration steps. By iteratively updating the weights and biases, we can converge to a local minima which will (hopefully) give us a model with a good prediction accuracy:

$$ w_{i,t+1} = w_{i, t} + \eta \cdot \frac{\partial E}{\partial w_{i, t}}$$
$$ b_{t+1} = b_{t} + \eta \cdot \frac{\partial E}{\partial b_{t}}$$

However, in the hidden layers, we don’t know what the desired output of the specific neurone is, this is where backpropagation comes in handy. Basically, we will propagate the errors of the output layer back through the network so that we can calculate the derivatives of the weights relative to the cost for all of the weights.

For this, we will need to define another equations. We replace the $\frac{\partial E}{\partial \hat{y}}$ with:

$$ \frac{\partial E}{\partial \hat{y}} = \sum w_i \cdot \frac{\partial E}{\partial z_i}$$

This tells us that for a node in a hidden layer, the derivative of the error relative to it's weights is equal to the weighted sums of the derivatives of the next layer. The weights used are simply the weights of the nodes in the next layer for that given node.

We can apply all the same equations as before when calculating the derivatives as before, we simply need to calculate the initial $\frac{\partial E}{\partial \hat{y}}$​ of the output layer, then use the derivative equations to propagate the derivatives through the network, then finally update the weights after we’ve calculated the relevant values.

## Recap of the algorithm

Here is a recap of the algorithm to implement a simple Neural Network, assuming you have a collection of numerical input vectors and the desired true/false output label:

1. Calculate the derivatives of the output neurons relative to the error using an input vector $x$ with a known output $y$

$$ \frac{\partial E}{\partial w_i} = (y - \hat{y}) \cdot f'(z) \cdot x_i$$
$$ \frac{\partial E}{\partial b} = (y - \hat{y}) \cdot f'(z) $$

2. Propagate the errors of the last layer to the second last layer, then propagate the errors of the second last layer to the third last layer, etc. where $\hat{y}$​ is the output of a hidden node 

$$ \frac{\partial E}{\partial \hat{y}} = \sum w_i \cdot \frac{\partial E}{\partial z_i}$$

3. Once you know the derivatives of all the weights and biases for all the neurons, update them using the following rules: 

$$ w_{i,t+1} = w_{i, t} + \eta \cdot \frac{\partial E}{\partial w_{i, t}}$$
$$ b_{t+1} = b_{t} + \eta \cdot \frac{\partial E}{\partial b_{t}}$$

## Python Implementation

Now that all the of the theoretical equations have been established, we can actually implement our model and test it on some real world data. For this example, we will be using the [UCI ML Breast Cancer Wisconsin (Diagnostic) dataset](https://archive.ics.uci.edu/dataset/17/breast+cancer+wisconsin+diagnostic). You can download a copy of the dataset directly, or you can import it through the [Scikit learn dataset module](https://scikit-learn.org/stable/modules/generated/sklearn.datasets.load_breast_cancer.html). We are trying to predict if a tumor is bening or malignant with several features such as the radius, symmetry, smoothness and texture.

```Python
from sklearn.datasets import load_breast_cancer
import numpy
import math
import random

# implementation of sigmoid neurones in a layer
class SigmoidLayer:

	# layer is defined by the input size and the number of neurones
	def __init__(self, input_size, number_of_neurones):
		self.input_size = input_size
		self.number_of_neurones = number_of_neurones

		# generate the weights as random numpy arrays of small values
		# different initiliaztion schemes can be used for the weights with varying experimental success
		self.biases = numpy.random.normal(0., 0.1, number_of_neurones)
		self.weights = numpy.random.normal(0., 0.1, (number_of_neurones, input_size))

	# defined the sigmoid function
	def sigmoid(self, z):
		return 1.0/(1.0 + math.exp(-z))

	# calculate the output of the neurones as a vector, based on an input vector to the layer
	def output(self, x):

		# initialize layer output, output will be of length self.number_of_neurones
		output_vector = []

		# iterate over each neurone in the layer
		for neurone in range(self.number_of_neurones):

			# retrieve the bias term for the given neurone
			z = self.biases[neurone]

			# calculate the weighted sum and add it to the initial bias term
			for feature in range(self.input_size):
				z += self.weights[neurone][feature] * x[feature]

			# apply the activation function
			neurone_output = self.sigmoid(z)

			# add the output of the given neurone to the layer output
			output_vector += [neurone_output]

		# return the output of the layer as a vector
		return numpy.array(output_vector)

	# calculate the backpropagation step for the layer as well as update the weights, based on the last input, output
	# and the derivatives of the layer, will output the derivatives needed for the previous layer
	def backpropagate(self, last_input, last_output, dE_dy, learning_rate):

		dE_dz = []

		# use the dE_dy of the layer to calculate the dE_dz of each neurone in the layer
		for neurone in range(self.number_of_neurones):

			# apply the derivative of the sigmoid function
			neurone_dE_dz = last_output[neurone] * (1.0 - last_output[neurone]) * dE_dy[neurone]

			# keep track of the derivatives of each neurone
			dE_dz += [neurone_dE_dz]

		dE_dz = numpy.array(dE_dz)

		# use the dE_dz derivative as well as the last input to update the weights and biases
		# this is the gradient descent step
		for neurone in range(self.number_of_neurones):

			# update the bias of each neurone in the layer
			self.biases[neurone] -= learning_rate * dE_dz[neurone]
			for feature in range(self.input_size):

				# calculate the derivative relative to each weight, then update each weight for each neurone
				self.weights[neurone][feature] -= learning_rate * last_input[feature] * dE_dz[neurone]

		# calculate the dE_dy derivative to be used by the following layer
		next_layer_dE_dy = numpy.zeros(self.input_size)

		# iterate over each neurone
		for neurone in range(self.number_of_neurones):

			# iterate over each weight
			for feature in range(self.input_size):

				# calculate the derivative using the backpropagation rule
				next_layer_dE_dy[feature] += self.weights[neurone][feature] * dE_dz[neurone]

		return next_layer_dE_dy

# implement Neural Network using sigmoid layer
class SigmoidFeedForwardNeuralNetwork:

	# we need the number and sizes of the layers, the input size and the learning rate for the network
	def __init__(self, learning_rate, input_size, layer_sizes):
		self.learning_rate = learning_rate
		self.layers = None

		# initialize each layer based on the defined sizes
		for layer in range(len(layer_sizes)):

			# input size of first layer is input size
			if layer == 0:
				self.layers = [SigmoidLayer(input_size, layer_sizes[layer])]
			# input size of every other layer is the size of the previous layer
			else:
				self.layers += [SigmoidLayer(layer_sizes[layer - 1], layer_sizes[layer])]

	# calculate the output of the neural network for a given input layer
	def predict_on_vector(self, x):

		# feed the output of each layer as the input to the next layer
		for layer in self.layers:
			x = layer.output(x)

		# return the output of the last layer
		return x

	# calculate the outputs of the neural network for a list of vectors
	def predict(self, X):

		# calculate the prediction for each vector
		predictions = []

		# make a prediction for each vector in the set
		for i in range(len(X)):

			prediction = self.predict_on_vector(X[i])
			predictions += [prediction]

		# return all of the predictions
		return numpy.array(predictions)

	def train(self, X, Y, iterations=1):

		# generate a list of indexes for the training samples
		training_samples = [i for i in range(len(X))]

		# do k iterations of training on the dataset
		for k in range(iterations):

			# print training progress
			print("Epoch : " + str(k))

			# randomly shuffle dataset to avoid getting stuck in local minima
			# random.shuffle(training_samples)

			# train on each sample
			for index in training_samples:
				self.train_on_vector(X[index], Y[index])

	# train the Neural Network on a single vector, this training scheme is know as "on-line" training
	# as the neural network is updated every time a new vector is given
	def train_on_vector(self, x, y):

		outputs = []
		inputs  = []

		# iterate over each layer and keep track of the inputs and output
		for layer in self.layers:
			inputs += [x]
			x = layer.output(x)
			outputs += [x]

		# calculate the error vector of the output neurones
		error_vector = x - y

		# iterate over each layer and apply the backpropagation, starting
		for i in range(len(self.layers)):
			index = len(self.layers) - 1 - i

			# update the weights of the layers and retrieve the next layer's error vector
			error_vector = self.layers[index].backpropagate(inputs[index], outputs[index], error_vector, self.learning_rate)




# Apply the logistic regression model to the UCI ML Breast Cancer Wisconsin (Diagnostic) dataset
X, Y = load_breast_cancer(return_X_y=True)

Y = [numpy.array([label]) for label in Y]

#split the data into training and testing sets
X_test = X[:100]
X_train = X[100:]

Y_test = Y[:100]
Y_train = Y[100:]

# Initialize the model
model = SigmoidFeedForwardNeuralNetwork(1e-1, 2, [64, 8, 1])

# Train the model on the training set
model.train(X_train, Y_train, iterations=25)

# calculate the accuracy on the training set
predictions = model.predict(X_train)

accuracy = 0
for i in range(len(predictions)):
	if predictions[i][0] >= 0.5 and Y_train[i][0] == 1:
		accuracy += 1
	elif predictions[i][0] < 0.5 and Y_train[i][0] == 0:
		accuracy += 1
		

print("Training Accuracy (%) = " + str(100. * accuracy / float(len(predictions))))

# calculate the accuracy on the testing set
predictions = model.predict(X_test)

accuracy = 0
for i in range(len(predictions)):
	if predictions[i][0] >= 0.5 and Y_test[i][0] == 1:
		accuracy += 1
	elif predictions[i][0] < 0.5 and Y_test[i][0] == 0:
		accuracy += 1

print("Testing Accuracy (%) = " + str(100. * accuracy / float(len(predictions))))
```