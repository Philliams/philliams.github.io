---
title: "Principled Development"
date: 2023-09-07T12:00:00Z
draft: true
tags: ["Career", "Software Engineering", "5 Year Recap"]
ShowReadingTime: true
---

I am a very strong believer in consistency. In fact, I think that consistency is at the heart of any engineering endeavor. Towards this end, I implemented what I call "Principled Development" into my daily work as a Machine Learning developer.

In this post, "Principled Development" refects to having a framework of clear and actionable heuristics for making technical decisions, and evaluating designs and implementations. Having a framework for making consistent technical decisions is incredibly valuable, it allows for alignment and a unified technical vision within the team, provides a scaffold for ideologically consistent development over time, and increases overall code quality.

The framework in question should be a set of clear, unambiguous, actionable and objective principles and heuristics to guide development. For example, "good code", "clean code" or "better abstractions" are all completely useless when evaluating code. For example, "good code" is a matter of personal taste, and does not relate to any actionable insighs to increasing code quality. On the other hand "easy to test", "easy to deploy" and "easy to modify" are all clear, unambiguous and actionable principles that lead to better code quality and better developer experience. Code that requires a lot of mocking or complex internal state is hard to test, and should be refactored to be more easily tested. Code that requires complex and slow deployment makes development more difficult, and should be changed to be deployed quickly via a single command. Code that requires a lot of pain staking changes to configuration files is hard to modify, and should be refactored such that changes can be quickly tested with minimal overhead.

The specific choice of principles may be different from one developer to another, or from one team to another. This is fine and expected, the key take-away is that developers should strive to develop their own set of principles, and to make every decision and to validate every design against their set of principles. Additionally, the principles would be expected to evolve over time and in the presence of new information.

My personal framework for principled development has 8 core tenets:

1. Explicitness
2. Single source of truth
3. Ease of testing
4. Short iteration cycles
5. Fail eagerly
6. Fail explicitely
7. Thin and flat
8. Ease of debugging

#### Explicitness

When reading code for a given function/class/module/etc., all definitions, dependencies and inputs should be explicitely identifiable from within the code. More precisely, a developer should be able to navigate the code where a function/data is used, to where the function/data is defined without any prior knowledge of the codebase.

Let's look at an example of a simple function that processes a dictionary that is expected to have a given schema. This data is static metadata that changes rarely, and is checked into the version control system. In the first example, we will load the dictionary from a JSON file stored on disk.

```Python
import os

def main():
    filepath = os.environ['SOME_FILE_PATH']
    data = load_json(filepath)
    do_logic(data)

if __name__ == '__main__':
    main()

```

The example above is extremely hard to validate without access to a running copy of the application. Some uncertainties include: how/where was the environment variable set? What is the value of the environment variable? What file was loaded? What are the contents/expected schema for the data?

All of these questions can be answered, but require either a running application, or prior knowledge of the codebase, since there are no imports, type hints or definitions that can be used to back-track.

For an alternative implementation, we can instead put the data into a separate module, define some type hints, and import the module itself.

```Python

# in data_module.py
from typing import TypedDict

class DummySchema(TypedDict):
    foo: str
    bar: int

data: DummySchema = {'foo': 'bar', 'bar' : 1234}

def get_data() -> DummySchema:
    return data

# in the main_script.py
import data_module

def main():
    
    data = data_module.get_data()
    do_logic(data)

if __name__ == '__main__':
    main()
```

The example above achieves the same functionality, as the first example, but in a much more explicit way. From the `main()` function, I can immediately view the schema via the type hint `DummySchema`, as well as validate the contents in `data_module.data`.

#### Single source of truth

For every process, and within the code, there should be a single, unambiguous source of truth. This means that we should only have a single approved/supported way of running tests, linting, deploying the application, etc. that is used both locally by developers and as a part of the build pipeline.

For example, in my sample repo [Python-Prefab](https://github.com/Philliams/Python-Prefab), a handful of commands are specified in the [Makefile](https://github.com/Philliams/Python-Prefab/blob/main/Makefile) and are used both locally and within the [CI pipeline](https://github.com/Philliams/Python-Prefab/blob/main/.github/workflows/CI.yml).

#### Ease of testing

Testing code is necessary and gives increased confidence when making significant changes. Code should strive to be as easy to test as possible. Tricky mocking logic, difficulties isolating global/environment variables or strict coupling to deployed environments should be eliminated. An ideal state to strive for, is to be able to test the majority of the logic (>90%) entire within unit tests with no mocking.

As an example, let's look at two implementations of some logic that will load data from the database, perform some transformations, and persist the result:

```Python
import psycopg2 # Library for making db connections

def do_main():

    # create query string for load
    query_string_load = ...

    # load data from db
    connection = psycopg2.connect(...)
    cursor = connection.cursor()
    cursor.execute(query_string_load)
    data = cursor.fetchall()

    # apply transformations
    for record in data:
        # do some data transformations
        do_mutate_data(record)

    # create query string for save
    query_string_save = ...
    cursor.execute(query_string_save, data)

if __name__ == "__main__":
    do_main()
```

In the example above, you would need to mock creating the db connection, executing queries and saving the data. This means that : 1) you need to mock a significant amount of the database interface (which will be a lot of work) and 2) your tests are tightly coupled to the internals of your logic.

An alternative implementation may look something like:

```Python

# in main_script.py
def load(cursor):
    # create query string for load
    query_string_load = ...

    # load data from db
    cursor.execute(query_string_load)
    data = cursor.fetchall()

    return data

def save(cursor, data):
    # create query string for save
    query_string_save = ...
    cursor.execute(query_string_save, data)

def do_logic(data):
    # apply transformations
    for record in data:
        # do some data transformations
        do_mutate_data(record)

    return data

def do_main():
    connection = psycopg2.connect(...)
    cursor = connection.cursor()

    data = load(cursor)
    result = do_logic(data)
    save(cursor, result)

if __name__ == "__main__":
    do_main()

```

In the second example above, we can now test the `do_logic` function on it's own, by simply passing in the correct data structure. This allows my tests to be decoupled from the IO logic. Additionally, if I want to test `do_main()`, I simple need to mock `load(...)` to return a premade object and `save(...)` can be mocked with a simple function to record the result in memory to be validated. Consequently, my tests are : 1) less effort to write, 2) decoupled from the internals of both my logic and the library api, and 3) allow me to test my entire main script within a unit test (IO excepted).

#### Short iteration cycles



#### Fail eagerly



#### Fail explicitely



#### Thin and flat



#### Ease of debugging


