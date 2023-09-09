---
title: "Generators and Coroutines in Python"
date: 2022-05-10T12:00:00Z
draft: false
tags: ["Python", "Software Engineering"]
ShowReadingTime: true
ShowCodeCopyButtons: true
---

Generators and Coroutines are very powerful tools in Python that can help simplify logic, speed up data-intensive programs or provide flexible and re-useable APIs. In this post, we will explore three main concepts in Python : Generators, Coroutines and Cogenerators.

## Generators

Generators in Python are objects that contain some sort of internal state, and know how to produce the "next" value in a sequence.

Before we talk about what generators are, we should talk about what problems they can help solve! By using generators you can:

1. Iterating over data structures in a way that decouples your logic from the data structure
2. Generators can be used to replace callbacks with iteration, you can perform work, and yield a value whenever you want to report back to the caller
3. Processing data in small chunks so that only a small portion of the data is ever loaded into memory (Lazy evaluation)

Generators provide many methods, but the ones that we will focus on are `__iter__` and `__next__`. `__next__` allows you to call `value = next(some_generator);` this call will tell the generator to update it's internal state and give you the next value. `__iter__` allows your generator to implement the Iterator interface such that you can iterate over your generator using the `element for element in some_generator` syntax (usually, if you already implement `__next__` your `__iter__` will just return `self`, otherwise you can have an object create a new iterable object and return that).

#### Generators using classes

Let's define a simple program that will use a generator to produce Fibonacci numbers. In this example, we will implement the generator class ourselves.

```Python
class FibonacciGenerator:

    def __init__(self, n1=0, n2=1, max_iters=100):
        self.max_iters = max_iters
        self.current_iter = 0
        self.n1 = n1
        self.n2 = n2

    def __next__(self):

        if self.current_iter < self.max_iters:
            self.current_iter += 1
            sum_ = self.n1 + self.n2
            self.n1 = self.n2
            self.n2 = sum_
            return sum_
        else:
            raise StopIteration

    def __iter__(self):
        return self
```

In the `__init__`, we set the current number of iteration, the max number of iterations and the first two Fibonacci numbers `n1` and `n2`. In the `__next__` method, we check if we are under the maximum number of iterations and if so compute the next Fibonacci number, update `n1` and `n2` and then return the next Fibonacci number. `__iter__` is very simple and we can just return the object since the `FibonacciGenerator` class implements `__next__`.

We can then use this class to easily compute and iterate over Fibonacci numbers. We can exhaust all of the numbers by invoking `[e for e in gen]`. If we try to get another value after the generator has been used up, an exception will be raised.

```Python
gen = FibonacciGenerator(max_iters=10)
nums = [e for e in gen]
print(nums)
try:
    v = next(gen)
except Exception as e:
    print("failed")
```

#### Generators using the Yield keyword

As seen above, we can implement a generator manually using a class. However, this requires a lot of boilerplate and somewhat obfuscates what the generator is actually doing when the internal state is more complex than a few integers.

However, Python can generate generator instance for us directly from function code when we use the `yield` keyword! Let's implement our Fibonacci number generator using `yield`.

```Python
def fibonacci_generator(n1=0, n2=1, max_iters=100):
    for i in range(max_iters):
        sum_ = n1 + n2
        n1 = n2
        n2 = sum_
        yield sum_
```

Looking at the code above, it is already much simpler and clearer than the class based example. When using `yield` in a function like this, Python will automatically turn the function into a generator instance, while the `yield` keyword will act somewhat like a return statement. More specifically, when `next(generator)` is called, the function will run as expected until it encounters the `yield` keyword, the value that was yielded is returned to the caller, and the function pauses until the called invoked `next(generator)` again.

We can examine the generator and we see that the behavior is identical to our class based example:

```Python
gen = fibonacci_generator(max_iters=10)
nums = [e for e in gen]
print(gen)
print(nums)
try:
    v = next(gen)
except Exception as e:
    print("failed")
```

#### Example of using a generator to process data structures

Now that we've seen the details of implementing and invoking generators, we can take a look at an example of implementing a generator to traverse a data structure, while implementing the logic separately.

Let's say that we have some data stored in a binary tree. Any logic that we want to perform on the tree would involve implementing our "business" logic and our traversal logic in the same place. Alternatively, we can implement a generator that will traverse the tree node by node, and yield the value at each step. We can them implement sum, min and max operations efficiently, without needing access to the internals of the traversal.

```Python
class Node:
    def __init__(self, val, l, r):
        self.val = val
        self.l = l
        self.r = r

def traverse_tree(root):
    yield root.val
    if root.l is not None:
        for e in traverse_tree(root.l):
            yield e
    if root.r is not None:
        for e in traverse_tree(root.r):
            yield e

if __name__ == '__main__':
    a = Node(1, None, None)
    b = Node(2, None, None)
    c = Node(4, None, None)
    d = Node(8, None, None)
    e = Node(-5, None, None)

    a.l = b
    a.r = c

    b.l = d
    c.l = e

    all_vals = [e for e in traverse_tree(a)]

    print(all_vals)
    max_ = a.val
    min_ = a.val

    for val in traverse_tree(a):
        if val > max_:
            max_ = val
        if val < min_:
            min_ = val

    print(max_, min_)
```

## Coroutines

Coroutines share a lot of similarities with generators, but they provide a few extra methods and a bit of a difference in how the `yield` keyword is used. In essence, coroutines consume values sent by the caller, instead of returning values to the caller. In terms of technical details, the main differences are:

1. Coroutines use `send(val)` instead of `__next__()`. The coroutine will then have access to the value sent.
2. Coroutines need to be “primed”. That means you need to initialize it properly before you can start using it (this will raise an error)
3. Like generators, coroutines are suspended on `yield` keyword, This is can lead to unintuitive behavior if not expected

Let's implement a simple coroutine that accepts values and prints them. The key change here is that we will access the value sent by the caller with `val = (yield)`.

```Python
def simple_coroutine(max_iters=5):
    for i in range(max_iters):
        print(f'before yield i = {i}')
        val = (yield)
        print(f"after yield, val = {val}, i = {i}")
```

To use the coroutine, we need to "prime" it by either calling `coroutine.send(None)` or `next(coroutine)` (these two statements are equivalent). Once the coroutine has been primed, we can iterate over it in the same manner as a generator, with the difference that `coroutine.send(val)` is used in place of `next(generator)`. Coroutines will even fail the same way as generators if exhausted.

```Python
coroutine = simple_coroutine()
# need to prime the coroutine
print('before priming')
next(coroutine)
print('before send')
coroutine.send('Dummy val a')
print('main thread after a')
coroutine.send('Dummy val b')
print('main thread after b')
coroutine.send('Dummy val c')
print('main thread after c')
coroutine.send('Dummy val d')

try:
    coroutine.send('Dummy val e')
except:
    print("failed")
```

## The Yield keyword

The yield keyword seems to behave unintuitively, but we can break down what exactly it does to understand the underlying model.

1. Function will run until it encounters `yield` keyword. The function is then suspended
2. If you `yield value`, then the value is returned to the caller of `send(…)` or `next()`
3. The function will then wait until the next time `send(…)` or `next()` is called. If a value is sent, you can access it by `value = (yield)`

Additionally, We can combine generator and coroutine syntax into `send_val = yield return_val`. This implies that we can have objects which will be both generators and coroutines.

## Co-Generators

I like to call objects that are both generators and coroutines, "Co-Generators" as it helps disambiguate how the object should be interacted with. We can now implement a co-generator which will both accept and yield values.

When dealing with co-generators, it is key to understand the statement `sent_val = yield return_val` executes in two distinct stages. Upon the `next(cogenerator)` or `cogenerator.send(None)`, the function will execute up until the `yield val` statement, which will immediately return the value to the caller. The function will then be suspended until the first call of `cogenerator.send(some_val)`, which will take the value, pass it into the function and will be assigned to `sent_val`. This means that you can have some external code run after `yield val` but before `val = (yield)`!

Below we can see an example of a co-generator that sends and yields values, with several print statements that will execute between both steps of the yield evaluation.

```Python
def complex_cogenerator(max_iters=5):
    print('start of cogenerator')
    for i in range(max_iters):
        print(f'start of loop, i={i}')
        val = yield i
        print(f'end of loop, i={i}, val={val}')
    print('end of cogenerator')
    yield None

if __name__ == '__main__':

    print('start of main')
    co_gen = complex_cogenerator()
    print('after cogenerator creation')
    v = next(co_gen)
    print(f'after cogenerator priming, v={v}')
    while v is not None:
        print(f'main thread before send, v={v}')
        v = co_gen.send('Dummy val a')
        print(f'main thread after send, v={v}')
```

When running this example, we will note a few things:

1. no logic runs when `complex_cogenerator()` is called. In fact this function behaves like an initializer, rather than an actual function.
2. The co-generator needs to be primed before it can be used. But after the priming, we can iterate over the co-generator by using a `while` loop.
3. The order of execution of the print statements is non-obvious, but makes sense when accounting for the two-step execution of the `a = yield b` statement.

## Conclusion

In this article, we took a look at generator classes, generators using `yield`, coroutines using `yield` and how to combine generators and coroutines into co-generators.

Hopefully you will be able to leverage this knowledge to build better abstractions around you data structures for more flexible, robust and performant code.