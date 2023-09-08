---
title: "Reflecting On My Career 5 Year In"
date: 2023-09-07T12:00:00Z
draft: true
tags: ["Career"]
ShowReadingTime: true
# cover:
#     image: "/posts/career_5_years/splash.jpg"
#     alt: "Moving on"
weight: 1 # Pin this post
---

This September I am taking a leave from my job to pursue a Master's of Science in Machine Learning at University College London. As I am opening a new chapter in my career, I find myself reflecting on some key takeaways and overarching themes of the first 5 years of my career.

## Background Context

I was fortunate enough to join the Machine Learning team as it was getting started, and was able to work on the project from a green-field initiative to a large-scale product used by customers. I've been working at my current company for about 5 years, went from intern, to Machine Learning Developer, and finally Machine Learning Team Lead. 

1. Machine Learning Intern (summer 2018)
2. Machine Learning Developer (May 2019 - June 2022)
3. Machine Learning Team Lead (June 2022 - August 2023)

The bulk of my work has been focused on time series forecasting for supply chain management. In plain english, we built systems to forecast how much of a given item will sell at a given store on a given day. Generating Machine Learning forecasts for time series data involves many difficult technical challenges, from infrastructure, to handling big data, and finally training accurate models.

## Key Concepts and Takeaways

When solving difficult technical problems, managing a large project, and generally navigating the challenges of large software projects, there were 4 main pillars that were key to our success :

1. Ownership : what does it mean to have ownership and how to meaningfully take ownership
2. Principled Development : the advantages of a consistent design and implementation philosophy 
3. Meta-strategies : ideas and strategies for adaptable problem solving
4. Technical Excellence : my opinions on producing high-quality software

#### Ownership

From low-level design to high-level project planning, ownership is central to succesfully enacting change. But before we can talk about what ownership means and how to achieve it, we need to agree on a definition of ownership.

> Ownership is a combination of authority to drive the course of action taken, and responsibility for the outcome.
> Ownership is also about making sure that the things that need to be done, get done

First of all, in order to take ownership of something, you need to be able to meaningfully influence the outcome and take responsibility for how it turns out. Towards this end, ownership can usually be achieved through 'hard' power and 'soft' power. Hard power comes in the form of your superior assigning you tasks. On the other hand, soft power is being able to achieve ends by persuading peers or superiors, without a way to force them to adopt a particular course of action. Soft power is more broadly applicable and is more interesting, since it can be achieved regardless of seniority and can be used outside of your immediate team.

A useful and straightforward way of achieving ownership via soft power is by being a known "expert". If you are the most knowledgeable person about a particular area (but not neccesarily the most senior overall), then people will consult you for future developments in that area. Consequently, you will be able to achieve ownership, as you will both be able to influence decision making via your input, as well as having responsibility by virtue of being the known "expert" for that area. One way of becoming the known "expert" is to be a champion. If you have an idea and champion it, then you can become the de-facto expert simply by being the person who did the work.

Another way of achieving is by ongoing discussions and mentorships. It can be difficult to suddenly convince someone of an idea the first time they encounter it. But on the flipside, if you've been having discussions about similar topics on an ongoing basis, and align yourselves before the fact, it can be much easier to get buy in, since the ground work has already been laid.

Finally, the last aspect of ownership is making sure that the right decisions are made, and that the necessary tasks are completed. It is often easy to avoid conflict, but it is key to push back against bad decisions and strategies, and to ensure the desired outcome.

#### Principled Development

Consistency is at the heart of any engineering endeavor. In this context, "Principled Development" is having a framework for making technical decisions and evaluating designs in a consistent way. Having a framework for making consistent technical decisions is incredibly valuable, it allows for alignment and a unified technical vision within the team, provides a scaffold for internally consistent development, and increases overall code quality.

The framework in question should be a set of clear, unambiguous, actionable and objective principles and heuristics to guide development. For example, "good code", "clean code" or "better abstractions" are all completely useless when evaluating code. For example, "good code" is a matter of personal taste, and does not relate to any actionable insighs to increasing code quality. On the other hand "easy to test", "easy to deploy" and "easy to modify" are all clear, unambiguous and actionable principles that lead to better code quality and better developer experience. Code that requires a lot of mocking or complex internal state is hard to test, and should be refactored to be more easily tested. Code that requires complex and slow deployment makes development more difficult, and should be changed to be deployed via a single command. Code that requires a lot of pain staking changes to configuration files is hard to modify, and should be refactored such that changes can be quickly tested with minimal overhead.

The specific choice of principles may be different from one developer to another, or from one team to another. This is fine and expected, the key take-away is that developers should strive to develop their own set of principles, and to make every decision and to validate every design against their set of principles. Additionally, the principles would be expected to evolve over time and in the presence of new information.

#### Meta Strategies

A lot of blog posts discuss the correct architecture or strategy for a given situation. In this post, we will not discuss strategies or architectures, but rather a meta-strategy. A meta-strategy is a strategy for choosing strategies. In the context of software development, a meta-strategy would not be a recommendation of a particular architecture or tech stack, but rather a actionable advice on how to evaluate and choose architectures and implenentations.

#### Technical Excellence
