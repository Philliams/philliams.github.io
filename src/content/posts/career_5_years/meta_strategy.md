---
title: "Meta-strategies for Software Development"
date: 2023-09-12T12:00:00Z
tags: ["Sotware Engineering", "Career", "5 Year Recap"]
ShowReadingTime: true
---

A lot of blog posts discuss the correct architecture or strategy for a given situation. In this post, we will not discuss strategies or architectures, but rather a meta-strategy. A meta-strategy is a strategy for choosing strategies. In the context of software development, a meta-strategy would not be a recommendation of a particular architecture or tech stack, but rather actionable advice on how to evaluate and choose architectures and implenentations. In this post, I will outline 6 core concepts and how they fit together to form my own personal meta-strategy:

1. Win conditions
2. Lose conditions
3. Tempo
4. Scaling
5. Variance
6. Risk

## Win and Lose conditions

When planning software projects, win and lose conditions are key. The basic idea is that:

> Win conditions are conditions, that if met, means the project has succeeded

> Lose conditions are conditions, that if met, mean the project has failed

An example of a win conditions might: be delivering a certain feature by a certain date, meeting all the requirements, or improving performance by X%.

An example of a lose conditions might be: failing to deliver a certain feature by the deadline, failing to meet Service Level Agreements (SLAs), or missing some requirements.

When making decisions about designs, architecture, tech stacks, or development plans, you need to make sure that the option chosen will satisfy your win conditions while avoiding your lose conditions. If you only have 100mb of data, choosing a complex big-data tool is the wrong approach, because it increases your chances of hitting a lose condition (missing deadlines) without contributing to your win conditions.

Additionally, it is important to note that none of the example win or lose conditions mention anything about code quality. Code quality is a tool for meeting win conditions and avoiding lose conditions. Poor code quality can mean that the software is not ready to be released on time, while good code quality may mean that new features are added on time and under budget. On the other hand, extremely high quality code delivered in 5 years does not help you if you need to meet a deadline in 6 months. Code quality, performance, scalability, tech stacks and architectures need to be chosen with a clear purpose in line. In the next section, I will discuss the concepts of tempo and scaling, and how they can help make technical decisions.

## Tempo and Scaling

Tempo and scaling are two concepts borrowed from competitive video games that are extremely relevant to software development. Tempo and scaling are two independent attributes that are given to a given move or choice:

> A tempo move is a move that gives immediate value, and may be neutral or harmful in the long term

> A scaling move is a move that gives increasing value over time, but may be neutral or harmful in the short term

An example of a tempo move is to implement a quick, hacky fix that solves a bug today, but will introduce technical debt that will need to be cleaned up later. An example of a scaling move is taking a few weeks to refactor some code to improve maintainability over time. It is worth noting a well, that tempo and scaling are not mutually exclusive. A very good design may provide both tempo and scaling. Inversely, a bad design may provide neither tempo or scaling while taking up time and effort.

The concept of tempo and scaling is tightly coupled to the concept of win/lose conditions. Tempo and scaling can only be meaningfully discussed through the lens of specific objectives in time. In fact, you can imagine win conditions and lose conditions as set points spaced out in time. You need to balance scaling and tempo so that you are able to meet your short term obligations, while not putting yourself in a position where you are not able to meet your long-term obligations. For example, taking on technical today to meet an objective next week may make sense. On the other hand, taking on technical debt now to get started quickly may not make sense if the deadline is in a year.

## Variance and Risk

The last two key concepts for meta-strategies are variance and risk:

> Variance describes how wide the range of plausible outcomes are. A strategy that is guaranteed to produce a given result is low-variance. A strategy that could produce many different outcomes is high-variance.

> Risk describes how likely a project is to fail. A project almost guaranteed to succeed is low-risk, while a project guaranteed to fail is high-risk.

Additionally, there are three main situations that a project can find itself in:

1. **Default Win** : a project that has a very high chance of succeeding for a given strategy
2. **Uncertain** : a project that has an equal chance of failure and success for a given strategy
3. **Default Lose** : a project that has a very high chance of failing for a given strategy

When evaluating strategies, we often lack the language and framework for properly discussing risks. Often, when people say that something is risky, they are really saying that the outcome is uncertain (high-variance). However, high-variance is not always a bad thing. For example, if your project is in a default-lose state, it may be worth adopting a high-variance strategy to get you into the uncertain state. This may seem unintuitive, but if you have a 95% chance of failure for a low-variance strategy, or a 50/50 chance of success or failure, then it is worth taking a gamble. You still have a 50% chance of losing, but your chances of success increased by 10x from 5% to 50%. Through this lens, we can reason about various strategies in a more analytic way, and can discover unintuitive strategies that are very good when explored thorougly.

### One-way doors

An interesting concept is the "One-Way Door". A one-way door is a decision that once made, is impossible or very expensive to undo. On the other hand, a two-way door is a decision that can easily be reverted down the line. One-way doors should be deferred to the last possible moment. If you implement a one-way door too early, you take on complexity now and open yourself up to very painful technical issues if the requirements were to change in the meantime. Additionally, if you are forced to implement a one-way door, then you likely have a very compelling reason to do so.

In other words, two-way doors decision can be made more lightly and eagerly, while one-way door decisions should be deferred to the last possible moment and should be considered much more carefully.

## My Meta-Strategy

Now that we have all the concepts for a meta-strategy, we can discuss my particular meta-strategy:

1. Lay out all the win conditions and lose conditions before any planning or design is done
2. Collect a wide variety of different solutions
3. Evaluate which solution most closely matches the win conditions
    - missing win conditions or hitting lose conditions is bad
    - wasted effort or extra complexity beyond win conditions is bad
    - if the strategy is default-win, high-variance is bad, low-variance is good -> risk is low, don't gamble
    - if the strategy is default-lose, low-variance is bad, high-variance is good -> risk is high, gamble for chance of success
4. Once a tentative solution is identified
    - break down solution into implementation effort
    - identify intermediate milestones that need to be met
    - identify the minimum amount of tempo needed to achieve intermediate and final milestones
    - any extra tempo beyond the minimum needed amount is bad
    - any un-allocated capacity is allocated to scaling
    - more un-allocated capacity is good, as it allows for more scaling effort
    - if solution turns out to not be suitable, revisit other solutions
5. Once a final solution is chosen
    - break down implementation work needed
    - plan immediate implementation needed for short-term deliverables
    - plan scaling work for any unused capacity
        - clean up technical debt
        - improve performance
        - improve tooling
        - improve testing
        - etc.
    - if possible, implement scaling effort early to enable later tempo work
6. After implementation is done, identify pain points to be resolved via future scaling work.


## Case Study

To put the meta-strategy into context, let's take a look at a case study that reflects a common situation that many projects find themselves in:

#### Context

Company A is implementing product Z. However, the project is way behind schedule and is currently not meeting the requirements. We need to pick a strategy to salvage the project. We are dealing with a legacy codebase that is unreliable, performs poorly and is poorly tested.

The current state completes a simple Machine Learning calculation in 3 days and has had several severe outages.

#### Win conditions
To achieve success, we need to implement functionality to perform an improved Machine Learning calculation in under 12 hours on a large volume of data. The deadline is in 3 months.

#### Lose conditions
To avoid failure, the project needs to be free of any major bugs, needs to be deployable by the professional services team, and must be able to handle real-world loads without failing.

#### Strategies

**Strategy 1** : This strategy is to follow the current development plan and to incrementally remedy the situation
- Variance : Low
- Risk : Very High
- Tempo : Low
- Scaling : Low
- Prognosis : 95% failure

**Strategy 2** : This strategy is to completely throw the old code away and re-write from scratch with new technologies
- Variance : Very high
- Risk : High
- Tempo : Moderate
- Scaling : Very High
- Prognosis : 50% failure

**Strategy 3** : This strategy is to add some testing and maintain the outer API, but to refactor the internals chunk by chunk
- Variance : Moderate
- Risk : Moderate
- Tempo : High
- Scaling : Moderate-High
- Prognosis : 25% failure

#### Strategy Chosen

In this case, we want to choose strategy #3. Strategy #1 is not suitable, since we are almost guaranteed to fail. Strategy #2 is an improvement over #1, since we have a much higher chance of success. However, with strategy #2 we are taking unneccesary risk. #3 is thus ideal, since we have a high chance of success without taking unneccesary risks.

#### Implementation Breakdown

We have 3 large "chunks" of internal logic to replace. Each chunk will take ~3 weeks to update. Additionally, we need a month to re-write all of tests. However, if we dedicate 2 weeks at the start of the development to set up the tooling, we can cut the work down to ~2 weeks per chunk and ~3 weeks for the tests. The timeline would then look like:

- weeks 0-2 : set up tooling
- weeks 2-5 : add new tests
- weeks 5-7 : refactor chunk #1
- weeks 7-9 : refactor chunk #2
- weeks 9-11 : refactor chunk #3
- week 12: finalize work for deadline.

Thus, we have gone from a project that was way behind and most likely to fail, to a project that delivers the requirements (i.e. performance boost and improved ML logic) on time while improving the overall code quality. We met the win conditions, avoided the lose conditions, avoided unneccesary effort and were able to allocate some effort to improving developer experience.
