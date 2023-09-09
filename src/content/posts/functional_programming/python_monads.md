---
title: "Monads in Python"
date: 2021-02-16T12:00:00Z
draft: false
tags: ["Python", "Functional Programming"]
ShowReadingTime: true
ShowCodeCopyButtons: true
---

Monads are a super interesting and useful design pattern often seen in functional programming languages such as Haskell. That being said, it is pretty simple to implement our own monads in Python.

When talking about Monads, there are three "main" things that I use to describe in practical terms what a Monad is and what it does:

1. Monads are essentially containers for values. In other words, you will have a Monad that will contain some arbitrary value or variable.
2. You can turn a regular variable into a Monad by taking whatever value you want and "wrapping" it with your Monad implementation.
3. You need to have a way to apply functions and transformations to Monads to get a new Monad out.

We'll talk a little bit more about what the exact terminology is used for the various properties of Monads as well as the specific implementation, but first let's work through a very simple Monad called the Maybe Monad.

## The Maybe Monad

The Maybe Monad is named the way that it is, since it is a simple Monad that can either contain a value or not (maybe it has a value and maybe it doesn't ).

When implementing a Monad (in this case the Maybe Monad), the first thing that we need to have is a way of turning - or "wrapping" - a value into an instance of the Maybe Monad. The function that does this is called the `unit` function. In our case we will be implementing the Monad as a class and as such our `unit` function will actually be the initializer.


```Python
class MaybeMonad:

	def __init__(self, value: object = None, contains_value: bool = True):
		self.value = value
		self.contains_value = contains_value
```

As you can see in the code snippet above, the first element of our Python Maybe Monad implementation is the unit function in the form of the initializer. In our instance, we will keep track of our inner value `self.value` as well as a flag to indicate if our Maybe Monad instance contains a value or not `self.contains_value` (this is needed so that it is still valid if `self.value` is `None` or `False`, as an alternative to checking if `self.value`).

Now we have a very simple class that may contain a value or not, we need a way to apply functions to the Monad. Enter the `bind` function. The `bind` function is a method on our Monad that takes another function, applies that function to the inner value inside of the Monad and returns a new Monad with the result. The key here is that all of the logic relevant to the behavior of the Monad is implemented in the `bind` function. In our case, the logic for handling values/exceptions will be the main logic implemented in the `bind` function, but for other Monad implementations such as lazy evaluation or complex error handling, you might implement different behavior in the `bind` function.

```Python
from collections.abc import Callable

class MaybeMonad:

	def __init__(self, value: object = None, contains_value: bool = True):
		self.value = value
		self.contains_value = contains_value

	def bind(self, f: Callable) -> 'MaybeMonad':

		if not self.contains_value:
			return MaybeMonad(None, contains_value=False) 

		try:
			result = f(self.value)
			return MaybeMonad(result)
		except:
			return MaybeMonad(None, contains_value=False)
```

As you can see above, our `MaybeMonad` class now has a `bind` method. The behavior of this Monad is to apply a function to the inner value, and either return a new Monad with the result, or a Monad with no inner value with the `self.contains_value` flag set to `False`. Using this Monad, we can now apply a bunch of operations that may or may not fail and simply check if it contains a value at the end of our sequence of operations.

Let's look at how we might use this Maybe Monad to compute a bunch of operations to a simple numerical type:

```Python
import numpy as np
from maybe_monad import MaybeMonad

value = 100
m1 = MaybeMonad(value)
print(m1.value) # 100
print(m1.contains_value) # True

m2 = m1.bind(np.sqrt)
print(m2.value) # 10.0

m3 = m2.bind(lambda x : x / 0)
print(m3.contains_value) # True
print(m3.value)

def exc(x):
	raise Exception('Failed')

m4 = m3.bind(exc)
print(m4.contains_value) # False
```

In the script above, we can see how we produce the Monad instance `m1` from value, we can inspect inside the Monad to see the value, we can also check the flag to see if there is in fact a value inside of the Monad. Next we can bind another function to `m1` to get `m2`, once again we get a new Monad which happens to have a value inside of it. Finally, we try to bind a function to `m2` which raises an exception. As a result we obtain a new Maybe Monad `m3`, which has no value inside of it and who's `self.contains_value` flag is set to `False` (since the function failed). Even in this simple example, we can see that Monads are pretty useful, since now we can apply a bunch of functions which may raise an exception, but without needing to have a try-catch block around every function call. All of the try-catch logic is captured inside of the `bind` method, reducing the amount of repeated code and you to apply the logic of your Monad to any arbitrary code without having to redo any of the work.

Next we'll build upon this concept and introduce the `FailureMonad` which will be an extension of the `MaybeMonad` that provides a bit of additional functionality.

## The Failure Monad

`MaybeMonad` is pretty useful, since we can use it as a way to sequence several function calls that might raise exceptions, and then pull the value out at the end if no exceptions occurred, but what if we wanted a little more information about where and how the function failed? To do this, we could implement a little more logic in the `bind` method to keep track of things like the stack trace and the input parameters as well as allow for arguments and keyword arguments to be passed in:

```Python
from collections.abc import Callable
from typing import Dict

import traceback

class FailureMonad:

	def __init__(self, value: object = None, error_status: Dict = None):
		self.value = value
		self.error_status = error_status

	def bind(self, f: Callable, *args, **kwargs) -> 'FailureMonad':

		if self.error_status:
			return FailureMonad(None, error_status=self.error_status)

		try:
			result = f(self.value, *args, **kwargs)
			return FailureMonad(result)
		except Exception as e:

			failure_status = {
				'trace' : traceback.format_exc(),
				'exc' : e,
				'args' : args,
				'kwargs' : kwargs
			}

			return FailureMonad(None, error_status=failure_status)
```

We can then use `FailureMonad` to apply a sequence of functions to a value (including `args` and `kwargs`) and then print out some information about the exception such as the traceback and the arguments passed:

```Python
import numpy as np
from failure_monad import FailureMonad

def dummy_func(a, b, c=3):
	return a + b + c

def exc(x):
	raise Exception('Failed')

value = 100
m1 = FailureMonad(value)
print(m1.value) # 100

m2 = m1.bind(np.sqrt)
print(m2.value) # 10.0


m3 = m2.bind(dummy_func, 1, c=2)
print(m3.value) # 13.0

m4 = m3.bind(exc)
print(m4.value) # None
print(m4.error_status) # {'trace' : ..., 'args' : (...,), 'kwargs' : {...}}
```

As you can see above, we can use a Monad to not only handle exceptions in a sequence of operations gracefully, but it can also keep track of useful metadata about exceptions so that you can have all of the logic for handling various types of exceptions in a single spot (as opposed to spread out across you program). This is super useful in the context of a production system where you might have different modes of failure (memory issues, timeouts, networking problems, etc.):

```Python
m = FailureMonad(...)

m = m.bind(func_1)
m = m.bind(func_2)
m = m.bind(func_3)

if m.error_status:
	e = m.error_status['exc']
    if isinstance(e, ...):
    	do_something()
    elif isinstance(e, ...):
    	do_something_else()
    else:
    	do_thing()
```

So far you might be thinking "Monads are useful, but basically you're just passing around some metadata in a fancy way". This is not the only use-case for Monads, next we'll be looking at a Lazy Monad to that Monads can also modify the behavior of your program in really useful ways beyond simple book-keeping operations.

## The Lazy Monad

The last example we'll look at is the `LazyMonad`. For the `LazyMonad` we are going to implement a Monad that will lazily evaluate all of functions bound to it. Hopefully this will illustrate the value of Monads beyond simple error catching, since now we can take arbitrary code, and turn it into a lazily evaluated pipeline.

First we will implement the `LazyMonad` itself, this will be accomplished by internally storing a function, and producing a new Monad which will return a function which itself will return the value of the function computed by the previous Monad(s):

```Python
from collections.abc import Callable
from typing import Dict

import traceback

class LazyMonad:

	def __init__(self, value: object):

		if isinstance(value, Callable):
			self.compute = value
		else:
			def return_val():
				return value

			self.compute = return_val

	def bind(self, f: Callable, *args, **kwargs) -> 'FailureMonad':

		def f_compute():
			return f(self.compute(), *args, **kwargs)

		return LazyMonad(f_compute)
```

In the code above, we can see that the `bind` operation will return a new Monad as with the other examples, but contrary to the other examples the inner value `self.compute` is actually a Callable which will compute all the previous steps when needed. We can then use our `LazyMonad` to demonstrate that arbitrary code can be lazily evaluated without needing to have any awareness of the inner workings of the `LazyMonad`:

```Python
import numpy as np
from lazy_monad import LazyMonad

def dummy_func1(e):
	print(f'dummy_1 : {e}')
	return e

def dummy_func2(e):
	print(f'dummy_2 : {e}')
	return e

def dummy_func3(e):
	print(f'dummy_3 : {e}')
	return e

print('Start')

value = 100
m1 = LazyMonad(value)
print('After init')
m2 = m1.bind(dummy_func1)
print('After 1')
m3 = m2.bind(dummy_func2)
print('After 2')
m4 = m3.bind(dummy_func3)
print('After 3')

print(m4.compute())

print('After Compute')
```

In the example above, we can see that none of the functions run during the  `.bind(...)` call, instead everything is calculated when `.compute()` is called.

The `LazyMonad` should give an indication of just how powerful Monads can be when used properly. You can essentially encode whatever logic, no matter how complex, in the `bind` method, and subsequently get the benefit of that logic on any arbitrary code by simply wrapping your variables with the given Monad.

## Conclusion

Monads are a very interesting and powerful design pattern in Functional languages that can be applied in Python to enable things such as elegant error handling or  turning your code into lazily evaluated pipelines with no changes to the code itself.

There are many theoretical Computer Science aspects to Monads, but the key is that you need two main operations:

1. Unit : Take a value and turn it into a Monad
2. Bind : Take a Monad, apply a function to it and return a new Monad

That being said, there are some really awesome resources for anyone looking to read more into the theory behind Monads such as Eric Lippert's blog or Adit Bhargava's "Functors, Applicatives, And Monads In Pictures".