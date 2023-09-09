---
title: "Decorators in Python"
date: 2021-02-01T12:00:00Z
draft: false
tags: ["Python", "Functional Programming"]
ShowReadingTime: true
ShowCodeCopyButtons: true
description: Decorators are an interesting and powerful tool based on some interesting concepts borrowed from functional programming.
---

In python, you may have seen some syntax that looks a little like this:

```python
@something
def foo():
	pass
```

The `@something` statement is called a decorator and is syntactic sugar allow you to concisely implement and use interesting concepts from functional programming called "Higher-order Functions" and "currying". Before we get into how and why we might use decorators in Python, let's talk about functional programming, Higher-Order Functions and currying.

## Currying

Currying is a technique for taking a function that takes multiple inputs, and converting it into a sequence of single-input functions. Let's look at a simple function that computes the sum of 3 numbers, and then curry it.

```Python
def sum(x, y, z):
	return x + y + z
    
print(sum(1, 2, 3))
```

If we were to curry the function, it would look something like this:

```Python
def sum(x):
	def _sum(y):
		def __sum(z):
			return x + y + z

		return __sum
	return _sum

print(sum(1)(2)(3))
```

There are a couple of things worth noting about this curried function:

1. The inner function(s) have access to the scope of the outer function(s)
2. The functions themselves return functions
3. To properly execute it, you need to do a bunch of successive function calls

Currying is not directly related to decorators, but it leads nicely into the next import concept to grasp when dealing with decorators : Higher-Order Functions.

## Higher-Order Functions

Higher-Order Functions are functions that take other functions as inputs and return a new function as an input. This is somewhat different to the curried functions from earlier, as they take in integers and return functions, but the concepts are similar.

Higher-Order Functions are super useful for modifying the behavior of a function from outside the function itself. Let's look at an example where we use a Higher-Order Function to retry a function that throws an exception:

```Python
def throws_exc():
	print('this function will raise an exception!')
	raise Exception('This Failed')
    
def higher_order_retry(f):

	def _retry():
		try:
    		f()
		except:
    		f()

	return _retry

new_function = higher_order_retry(throws_exc)

new_function() # this will print twice!
```

In the code snippet above the `higher_order_retry` function is in fact a Higher-Order Function. It will take in a function pointer `f` and will return a new function pointer that wraps the original one in a try-catch block.

Higher-Order Functions are clearly powerful, since I can now write my try-catch logic once, and use it everywhere I want in my code! The main issue with this type of approach is that the `higher_order_retry(f)()` syntax is pretty cumbersome and we need to add this verbose function call anywhere that we want to modify the behavior of `f`.

## Decorators

Enter decorators. Decorators are Python syntactic sugar that allows us to apply Higher-Order Functions to a function definition in a single line of code, and have that higher order logic be automatically applied anywhere that the function is used.

First, we implement our decorator in the form of a function, here the inner block `__retry` accepts any number of args and kwargs and passes them along to the function being wrapped.

```Python
def retry_decorator(f):

	def __retry(*args, **kwargs):
		try:
			return f(*args, **kwargs)
		except:
			return f(*args, **kwargs)

	return __retry
```

Next, we can use the `@decorator` syntax to apply our decorator to any function we care about:

```Python
@retry_decorator
def throws_exception(a, b=None):
	print(f'a={a}, b={b}')
	raise Exception('This function failed')

throws_exception(1, b=2) # this will print twice!
```

This is equivalent to the following implementation without using decorators:

```Python
def throws_exception(a, b=None):
	print(f'a={a}, b={b}')
	raise Exception('This function failed')

throws_exception = retry_decorator(throws_exception)
throws_exception(1, b=2) # this will print twice!
```

Or this implementation if you want to explicitly use the Higher-Order Function every time:

```Python
retry_decorator(throws_exception)(1, b=2)
```

Now that we know what decorators are, how they work and how to implement them, we can finally talk about why you might want to use decorators.

Decorators are a really awesome way to modify the behavior of the function without modifying the code inside of the function. This allows you to solver certain types of problems in a generic and re-useable way.

## Takeaways

Decorators are useful whenever you want to modify the behavior of some code in a generic way from outside the function itself. A few common situations where decorators are often used would be:

1. Retrying a flakey operation (for example exponential back off for network communication). By implementing a retry decorator, you can have all of your network communication use the same retry strategy without duplicate or repeated code.

2. Logging/debugging code can be made much easier by implementing decorators that print out all of the inputs to a given function, allowing you to easily spot check every place where a function is called while only needing to add a single line of code at the function definition.

3. Advanced functional programming techniques such as Monads also benefit from the use of decorators and can allow you to use exotic and powerful design patterns while keeping the code clean and concise.

In conclusion, by using decorators, you can reduce repeated or duplicated code, make your software cleaner and easier to maintain, make logging and debugging easier as well as seamlessly integrate more exotic design patterns without adding visual clutter or verbosity.
