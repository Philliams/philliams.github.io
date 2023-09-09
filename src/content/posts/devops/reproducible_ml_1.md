---
title: "Reproducible software in research using Python - Part 1"
date: 2021-06-19T12:00:00Z
draft: false
tags: ["Python", "Software Engineering", "Machine Learning"]
ShowReadingTime: true
ShowCodeCopyButtons: true
---

One of the big issues in Machine Learning research is reproducibility. In fields like biology that have many experimental variables and uncertainties, it is expected that results may be difficult to reproduce due to small sample sizes and the inherent complexity of the research. However, there is no excuse for Machine Learning research to be anything but trivial to reproduce.

In this blog post, I will be demonstrating ways to make the software environment used for an experiment easily replicated as well as ways to add testing as a part of the experimental process to catch errors that might threaten the integrity of the results. Additionally, I will show how both of these elements can be automated, to remove any human error from the equation. Ideally, the entire experimental setup should be automated, such that it can be replicated from a handful of commands.

The first step to reproducible results is being able to precisely replicate the dependencies of the project. More often than not, replicating the data is straightforward, as the datasets are often published online as is. The main challenge is replicating the software environment - such as the libraries and versions - used in the experiments. 

In this article, we will be discussing the use of `Conda` and `make` to automate the setup and teardown of python environments to allow for easy replication of the Python environment. We will be also discuss how we can use `make` and `pytest` to run unit tests, monitor code coverage and finally run our experiments.

The main idea is that by pre-emptively adopting certain tools and automating our experiment workflow, we can produce high-quality results that can be replicated by anyone with `Conda` and `Make` installed.

## Prerequisites

This guide is specific to windows 10, however most of the steps are applicable in Linux or have direct counterparts.

Tools:
- Chocolatey - used to install `Make` (use `apt-get` instead of `chocolatey` on Linux)
- GNU Make - Install via `choco install make` on windows
- Conda - Used for creating Python environments

## Environment setup and teardown

`Conda` is one of many tools (one popular alternative is `pipenv`) that can be used to create Python virtual environments. Virtual environments are used so that you can manage several independent python installations, each with their own versions of installed libraries, without conflict on a single machine. This is great for managing your own project dependencies as well as avoiding cross-contamination and conflicting packages when working on more than one code-base.

With `Conda`, you can specify your environment in a dependencies file. You can then create a Python environment directly from a configuration file and have all of the specified libraries automatically installed. As such, if we put all of the library versions we need in this environment file, we can not only recreate or update our environment as needed, but anyone who wants to replicate our setup can do so directly from the environment file.

Here is an example of a `Conda` environment file (named `env.yaml`) that installs `pandas`, `numpy`, `scikit-learn` and `pytorch` for Python 3.8:

```yaml
name: my_env # your env name
channels:
  - conda-forge # where conda pulls packages from
  - pytorch
dependencies: # all of your library versions
  - python=3.8 # your python version
  - numpy=1.20.*
  - pandas=1.2.*
  - scikit-learn=0.24.*
  - pytest
  - pytorch
  - torchvision
  - torchaudio
  - cudatoolkit=10.2
```

To create and use the environment, run the following commands in the shell/terminal:

1. `conda env create -f .\env.yaml` - This will create the environment and install dependencies defined in env.yaml file.
2. `conda activate my_env` - This will enable your environment in the current shell. If you type python, you should see Python 3.8 as well as be able to import pandas and numpy (among other packages)

Thus, if you define the required libraries in your environment file and run all of your experiment code from that environment, anyone who wants to replicate your results can re-create the environment trivially using a single command.

Note : if there are any issues with an environment, it can be deleted with the command `conda env remove -n my_env`.

## Determinism and validation

The next component of reproducible (and correct) research is making sure that the experiment code is deterministic and  does not contain any significant bugs or errata. In this context, determinism means that if you run the same code twice, it should produce the same result both times. For example, this might mean that any random number generators are seeded such that if you are randomly shuffling your data, it will be randomly shuffled the same way, every time.

One of the best ways to ensure that your experiment is deterministic is to simply run it several times, and check if produces the same result. In fact, you could consider testing for determinism as a part of testing the greater validity of the entire experiment.

This leads to my next point about reproducible research : testing. There are many different ways of testing code, and many paradigms that one can read about. A good starting point is to at least have unit tests for your code. A unit test is essentially a small, self contained test that will execute a small number of functions or methods and test that it behaves as expected. Obviously this is not sufficient to guarantee that the program is error free, but having a comprehensive set of unit tests that cover the expected cases of your program goes a long way to proving that your program is valid. Additionally, you can have a set of tests that will run your entire experiment multiple times and compare the results to ensure determinism. This way, you can run the tests whenever making a significant change to the code to guarantee that no errors or non-determinism have crept into the experimental setup.

In practice, unit tests and code coverage can be implemented using the `pytest` and `pytest-cov` libraries. Running the command `python -m pytest --cov=unittests` will run all of the unit tests in the `unittests` folder as well as check the code coverage. Code coverage is an interesting metric, since it can help you catch any parts of the experimental code that aren't adequately tested. This can help detect and resolve breaking issues early.

## Makefiles and Automation

The final element of a reproducible code setup is to automate everything so that small variations in commands don't influence the final results or lead to divergent experimental environments. `Make` is a great tool for lightweight automation. In essence, a `makefile` defines a set of procedures that can easily be invoked, as well as store some variables for the experimental setup. To tie the automation back to the dependencies and unit tests, we can implement a `makefile` that will allow us to delete old environments, re-create a fresh environment unsing `Conda`, run all of the unit tests using `pytest` and then run the experiment proper.

Here is a sample implementation of a `makefile` saved in your project directory with the file name `makefile`:


```makefile
env_file ?= ./env.yaml # this is my env_file path
env_name ?= my_env # this is my env name

env:
	conda env remove -n ${env_name} # delete old env
	conda env create -f ${env_file} # create new one from env.yaml

test:
	python -m pytest unittests/ # run all the unit tests

run:
	python -m main.py # run my main program

# this combines test and run
full: test run
```

By running the command `make env`, my old environment will get deleted and then a fresh environment will be created to specification from my `env.yaml` file using `Conda`. Next, I can run all of my unit tests with the command `make test`, this will give me a report of which tests fail and which tests pass, in addition to reporting the percentage of my code that is tested. Finally, I can run my main experiment script with the command `make run`. I can also combine multiple commands together as can be seen in the `make full` command, which will run all of my tests, and if they pass it will run my experiment.

## Conclusion

In conclusion, by implementing my research code using `Conda`, `Make` and `pytest`, I can make my results easy to reproduce by providing a full specification of the dependencies, as well as increase the confidence that the code is correct by testing the code regularly for determinism and errors as a part of my experimental process.

The task of reproducing or validating my code has gone from a complex process to a sequence of three simple steps:

1. `make env`
2. `conda activate my_env`
3. `make run`

We've shown that two tools ( `make` and `conda` ) can be used to automate the reproduction of results, however any similar setup with different technologies is equally valid. The key takeaway is that the availability of tools and the ease with which code can be automated means that there is no excuse for Machine Learning research to not provide clean code and an automated methodology as a part of the publishing process.

Many papers have been retracted due to errors that should have been caught early on, and many more have results that can never truly be verified since either the code is not available or there are severe gaps in the methodology to properly re-run the experiment. This is unacceptable and we should all do our part to adopt tool for sharing and reproducing each others results, since the results contained in papers that cannot easily be reproduced are at best suspect and at worst useless.