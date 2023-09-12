---
title: "University College London - Part 0"
date: 2023-09-07T12:00:00Z
draft: true
tags: ["Career", "5 Year Recap"]
ShowReadingTime: true
# cover:
#     image: "/posts/career_5_years/splash.jpg"
#     alt: "Moving on"
weight: 1 # Pin this post
---

This September I am taking a leave from my job at $dayjob$ to pursue a Master's of Science in Machine Learning at University College London. As I am opening a new chapter in my life, I want to reflect and write down some of the key themes from my first 5 years in industry.

## Background Context

At $dayjob$, the bulk of my work was focused on time series forecasting for supply chain management. In plain english, we built systems to forecast how much of a given item will sell at a given store on a given day. Producing these forecasts involved a wide variety of technologies from infrastructure, to big data, and finally various machine learning models. I was fortunate enough to join the Machine Learning team as it was getting started, and was able to work on the project from a green-field initiative to a large-scale product used by customers. In that time, I went from intern, to Machine Learning Developer, and finally Machine Learning Team Lead:

1. Machine Learning Intern (summer 2018)
    - Worked on incorporating new sources of data into our time series forecasts
    - Technologies: Python, Jupyter notebooks, Scikit-Learn, git
2. Machine Learning Developer (May 2019 - June 2022)
    - Worked on implemented ML and big data systems for large-scale time series forecasting
    - Technologies: Docker, Kubernetes, Python, PySpark, Dask, Argo Workflows, Github Actions, Scikit-learn, Optuna
3. Machine Learning Team Lead (June 2022 - August 2023)
    - Lead feature generation team (~8 developers) and was responsible for Feature Generation module and related functionality

During my time as team lead, we overcame several challenges and had some big wins. Notably, doing a full re-write of the module to improve runtime by 5x, and implementing incremental logic to improve forecasting time by a factor of 20x. As such, this post will focus on things that I found key for succesfully running a large project rather than specific technical addvice.

## Key Concepts and Takeaways

When going from a green-field project to an enterprise product used by large-scale customers, there were 4 key ingredients to success. These four elements do not encapsulate everything needed to run a project, but if any one of these elements were missing, then the project would have been in a much rougher spot.

1. Ownership
2. Meta-strategies
3. Principled Development
4. Technical Excellence

### Ownership

As a team lead, I found that ownership was probably my single most imporant duty. Making sure that the right decisions were chosen, and ensuring that the that things that need to be done, get done was the difference between a great and terrible outcome. Sometimes, this mean doing technical due diligence to make sure that our designs made sense, that things were easy to test and deploy, and overall ensure the quality of the code. Other times, ownership meant involving myself into discussions outside of my direct responsibilities to avoid problems down the road.

> Ownership is also about making sure that the things that need to be done, get done

### Principled Development

In chess, there is the concept of "Principled Play". The idea is that there is a set of principles that you should strive to follow, and that you should only break them if you have a very strong reason to deviate from the principles. In the context of software development, this means having a consistent approach to design and problem solving. During my time at $dayjob$, I developped a framework of **unambiguous**, **actionable** and (mostly) **objective** heuristics for evaluating designs and architecture. I want to emphasize that the heuristics need to be actionable, unambiguous and objective. A lot of the time, the advice that is given is that you need to write "clean" code, or "good" code. That advice is worse than useless:

1. Subjective : "good"/"clean" are really just matters of taste that will vary a lot between developers, and will vary heavily based on experience, language, framework and team culture.
2. Not Actionable : There is no specific recommendation of how to make the code "good" or "clean". But rather the implication is that there exists some nebulous definition of "good" and that you should just know how to achieve it.
3. Ambiguous : it is not clear how to quantify or measure if something is "good" or "bad" at any level. You can't point to a specific part of the code and give a clear recommendation on how to improve it.

However, there are some heuristics that **are** unambiguous, actional and objective. These allow you to align with other team members for a consistent development philophy and style, make the implementation of the code more cohesive and allows you to provide clear and actionable feedback on design and pull requests. Some of my favorite ones are:

1. Testable: Is your code easy to test? The ease of testing can be measure by how much mocking you need to do, the complexity (less complex is better) intermediate state you need to set up before you can test, and how much of the code can be tested without needing to setup a specific environment or deploy it (fewer requriements is better).
2. Deployable: Is your code easy to deploy? The ease of deployment can be measure by how much configuration/parameters are needed to get something simple up and running, how many other services need to be deployed as prerequisites, how long it takes to deploy (faster is better), and how much of the deployment can be feasibly automated (more automation is better).
3. Debuggability : Is your code easy to debug? The ease of debugging can be measure by how much effort is needed to access some internal state (easier to access is better), if the application can be run with a debugger enabled, and how long the iteration cycle to make and test a change is (shorter iteration cycle is better).

In my experience, having a set of unambiguous, actionable and objective guiding principled for development has been key to aligning on design, and has led to robust, performant and high-quality software. A full write-up of my thoughts can be found in the [Principled Development]( {{< relref "posts/career_5_years/principled_excellence.md" >}} ) post.


### Meta Strategies

A meta-strategy is a strategy for choosing which strategy to apply in a given situation. For example, monoliths an micro-services are both software development strategies that have various advantages and disadvantages. Rather than always using either monoliths or micro-services, a meta-strategy would give you a consistent way to choose which architecture, design or strategy to use in any given situation.

Meta-strategies can also apply to more team or project oriented questions, and can be used in a technical or non-technical capacity. For example, decisions such as whether to refactor code or keep it as-is, whether to pick design A or B, or whether to go with business plan X or Y, can all be resolved if you have a robust meta-strategy.

My personal meta-strategy is outlined in the [Meta-Strategy]( {{< relref "posts/career_5_years/meta_strategy.md" >}} ) post, but can be roughly boiled down to a few key steps:

1. Be clear and unambiguous in specifying exactly the problem you are trying to solve
2. Identify the win conditions that need to be met (requirements) and loss conditions that need to be avoided (i.e. missing deadlines)
3. Evaluate strategies based on how they meet the requirements and avoid the loss conditions. Avoid any complexity beyond exactly the requirements.

Having a clear and actionable meta-strategy allows for difficult decisions to be made in a consistent and justifiable way, and can even help communicate the reasoning to various stake holders.

### Technical Excellence

Technical excellence is related to both meta-strategies and principled development. Having a strong understandings of the limits and features of various technologies, architectures and algorithms provides both more information to make better decisions and the capcity for better execution of the chosen strategy. Technical excellence feeds into the principles you adopt and informs the variables accounted for in your meta-strategy. On the other hand, robust principles and meta-strategy give context and ground your technical expertise.

> We are what we repeatedly do. Excellence, then, is not an act but a habit. - Aristotle

In particular, technical excellence is not an innate characteristic, but rather something that needs to be diligently practiced at both an individual level and at a team level. At an individual level, technical excellence is achieved by learning and experimenting. Trying new technologies, running experiments for various architectures, and exploring new best practices. As a team, maintaining code quality is like fighting against gravity. Tt is difficult to for the code quality to stay at the same level, it is easy to make the code worse, and almost impossible to improve code quality. However, improving code quality is still possible even on large enterprise projects. The key is to have the discipline to continuously improve developper experience. Reducing build times, enabled debuggers, separating concerns so tests can be executed locally, and pushing back on complexity will ensure that iteration times are short and that developers are nimble and productive. From there, it is much easier to make changes as needed. From there, it is a lot easier to achieve sustainable technical excellence, since the team has all the tools to modify large portions of code quickly and with little risk.

## Further Reading

This post was intended as a quick overview of the main four pillars that led to the ongoing success of my work and team at $dayjob$. More detailed write-ups that dig into the nuances are available:

- [Ownership]( {{< relref "posts/career_5_years/ownership.md" >}} )
- [Meta-Strategy]( {{< relref "posts/career_5_years/meta_strategy.md" >}} )
- [Principled Development and Technical Excellence]( {{< relref "posts/career_5_years/principled_excellence.md" >}} )
