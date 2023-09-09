---
title: "Principled Development and Technical Excellence"
date: 2023-09-07T12:00:00Z
draft: true
tags: ["Career", "Software Engineering"]
ShowReadingTime: true
---

Consistency is at the heart of any engineering endeavor. In this context, "Principled Development" is having a framework for making technical decisions and evaluating designs in a consistent way. Having a framework for making consistent technical decisions is incredibly valuable, it allows for alignment and a unified technical vision within the team, provides a scaffold for internally consistent development, and increases overall code quality.

The framework in question should be a set of clear, unambiguous, actionable and objective principles and heuristics to guide development. For example, "good code", "clean code" or "better abstractions" are all completely useless when evaluating code. For example, "good code" is a matter of personal taste, and does not relate to any actionable insighs to increasing code quality. On the other hand "easy to test", "easy to deploy" and "easy to modify" are all clear, unambiguous and actionable principles that lead to better code quality and better developer experience. Code that requires a lot of mocking or complex internal state is hard to test, and should be refactored to be more easily tested. Code that requires complex and slow deployment makes development more difficult, and should be changed to be deployed via a single command. Code that requires a lot of pain staking changes to configuration files is hard to modify, and should be refactored such that changes can be quickly tested with minimal overhead.

The specific choice of principles may be different from one developer to another, or from one team to another. This is fine and expected, the key take-away is that developers should strive to develop their own set of principles, and to make every decision and to validate every design against their set of principles. Additionally, the principles would be expected to evolve over time and in the presence of new information.