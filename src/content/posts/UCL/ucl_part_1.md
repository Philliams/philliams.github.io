---
title: "University College London - Part 1"
date: 2024-05-24T12:00:00Z
tags: ["UCL", "Grad School"]
ShowReadingTime: true
weight: 1 # Pin this post
---

I wrote my last final this week, and so I wanted to take the opportunity to give a recap of my first two terms in Machine Learning at University College London. 

 

# First weeks in London 

While courses started mid-October, I ended up moving to London sometime mid-September to give me some time to get settled in. Notably, I spent about 2 weeks reviewing “Mathematics for Machine Learning” by Deisenroth et al. Having worked in industry for the past 4 years, I was a bit rusty and so going through the practice problems was a great way to refresh my skills and get into the right mindset for the work to come. 

 

# Term 1 (Oct 2023 – Dec 2023) 

The first term consisted of 4 modules, with most of the content being foundational and expository. I found that the key takeaways of term 1 were all about the fundamentals and gaining fluency. Overall, we did a lot of math, and as a result built a lot of familiarity with the notation and concepts that show up often in machine learning. Some of the courses covered more theoretical aspects of Machine Learning, such as proving error bounds under various assumptions. Other courses were more procedural in nature, where we were expected to replicate and apply various algorithms for learning and inference. 

Listed below are the modules I took in the first term. In terms of overall impression, I think that Bayesian Deep Learning and Graphical Models were quite excellent modules, while Supervised Learning and Robotics Systems Engineering were alright, but could a bit of polish on some rough edges. 

## Supervised Learning 

This module was foundational, with a focus on theory and little application. We had 2 course works, which involved problems such as proving the "No Free Lunch" theorem or deriving error bounds for various learning algorithms. Also, the course had a final which involved solving some key problems presented throughout the module. Due to my engineering undergrad, I am very comfortable with calculus, but less so with more abstract branches of math. As such, I learned a lot in this course and acquired various mathematical tools. Throughout the course, the material is presented from first principles without stating the end-goal, such that everything is derived from known facts and assumptions. When unfamiliar with the content, this approach can feel very much like taking a path without knowing the destination, and so it is not clear which information is key or why a given identity is relevant. This course was quite interesting but assumes a lot in terms of pre-existing knowledge which can be difficult for students that lack a strong math background. 

## Graphical Models 

This module covered a wide range of basic topics. From defining Belief Networks and Markov Networks, to performing inference in trees and loopy networks, we covered a wide range of topics. There was a single coursework, where we implemented many graph-based models and algorithms (such as solving the Ising model) in a wide variety of settings. This course was very expositional, in that we covered a wide range of topics in moderate depth and gained fluency in the language of graph-based models. Additionally, there was a final exam which was mainly focused around applying the algorithms learned to simple problems. This course was quite good, and I feel like I gained a lot. The lectures and evaluations felt fair, the lectures were clearly presented and laid out, and understanding was almost a given if you put in the effort to go through all the content in detail. 

## Bayesian Deep Learning 

This was by far my favorite course in the first term. The first half of the module covered Bayesian statistics, and how they can be applied to machine learning problems. In the second half of the term, we covered how introducing deep models complicates the setting, and techniques for tackling those issues (such as sampling, Bayesian last layer). There were two notebook-based course works, which tied in well with the content. The coursework involved implementing various models and algorithms and exploring their behaviour in simple settings. The final exam had more theory-based questions, such as explaining the limitations and settings in which one might use Bayesian methods and which algorithms to use. I believe that this module was a great mix of theory and applied learning. Additionally, given the number of papers which make use of Bayesian concepts, gaining a familiarity with Bayesian Deep Learning has greatly aided my comprehension of advanced research topics. This course is excellent, and I would highly recommend taking it. 

## Robotics System Engineering 

This module was very engineering oriented. We covered the main concepts in robotics engineering, namely forward and inverse kinematics and dynamics. This course was 100% coursework based, split into three assignments. The first assignment required implementing forward kinematics using a ROS Noetic based simulator. While the concepts were not unduly difficult, the simulator's complexity introduced a learning curve. The second assignment consisted of inverse kinematics, and the final coursework was related to forward and inverse dynamics. Overall, the course did a great job of imparting a working understanding of the problems and techniques used in robotics, though the simulator aspect could be improved. 

# Term 2 (Jan 2024 – April 2024) 

The second term was a mix of advanced and applied topics. Some modules, such as Machine Learning Seminar, built upon the first term and delved into more research-oriented topics. However, modules such as Applied Machine Learning were much more practical in nature. This mix was quite nice, as it allows students tailor the level of research or industry focus that they are interested in. Having worked in industry for a few years, I avoided the applied modules in favor of a heavily theory oriented second term, to expose myself to as many new topics as possible. 

Listed below are the modules I took in term 2. I found Multi-Agent AI and ML Seminar to be excellent and among my favorite courses. Statistical NLP was a good course, but not particularly noteworthy. Finally, Reinforcement Learning was quite a painful course. Tunnel vision on theory while ignoring recent advances, poorly organized coursework and a difficult final detracted from what should be a very interesting and useful module. 

## Machine Learning Seminar 

This course was by far the best module in term 2. We covered Gaussian Processes, Bayesian Optimization, Numerical Integration, Message Passing and Meta learning. The first 5 weeks were lectures on the listed topics, while the last 5 weeks involved reviewing various published papers and presenting them to the class. The evaluation for the course consisted of weekly quizzes, a paper review and a group presentation. The weekly quizzes were somewhat difficult, as a high level of detail is expected. The paper review required reading an assigned publication and acting as a conference reviewer. This gave insight into the peer-review process and dealing with published research. Finally, the group project was a paper review and subsequent presentation. The assigned papers were quite varied, and so listening to the different groups present gave a great overview of several topics. Overall, the course was excellent. The evaluations were fair and not overly difficult, and the content itself gave a great view into how theoretical topics appear in publications. 

## Statistical Natural Language Processing 

This course covered a wide range of topics in Machine Learning, starting from topics such as *n*-gram models and feature engineering, all the way to Large Language Models, safety and adversarial attacks. The evaluation was a single open-ended research project on an NLP related topic. Since I had done research before, it was relatively easy to achieve a good mark. However, several students who had never dealt with either NLP or research before found it difficult. Overall, the course was fine, with a bit of a sink-or-swim dynamic due to the nature of the evaluation. 

## Reinforcement Learning 

This course was very theoretical. The bulk of the module related to topics such as the Bellman Equations, the fundamentals of dynamic programming, and showing that algorithms do or do not converge to optimality under various convergence. The evaluation consisted of a notebook-based coursework and a final exam. The notebook itself was a mix of practical questions, such as implementing Policy Gradients or Upper-Confidence Bound, as well as theoretical questions, such as proving that a given operator converges to optimality or deriving the expected weight update under a Markov-Decision Process. The final consisted of questions such as deriving updates given a Markov Decision Process or recalling definitions and proofs of several algorithms covered throughout the term. Similarly to Supervised Learning in term 1, this module often presented information without providing context of motivation. Many students seemed disappointed with the module, as it did not cover the implementation of Reinforcement Learning in practical settings, but rather was entirely focused on the theoretical underpinnings of various algorithms. Overall, this course was the worst module across both terms, as the course itself was quite difficult and poorly structured. 

 

## Multi-Agent Artificial Intelligence 

This course was quite excellent and did a great job of covering theoretical topics and relating them to practical settings. The module covered topics such as game theory, Nash equilibria and multi-agent Reinforcement Learning. The evaluations were a notebook-based coursework and an open-ended research project. The notebook coursework did a great job of bridging the theoretical concepts covered in class, and the practical implementations. Some of the questions involved implementing Support Enumeration, computing optimal policies for given matrix games, and solving potential games. Similarly to Statistical NLP, the open-ended research project can be quite easy or difficult depending on the amount of research a student has done prior. Overall, the course was excellent and did a pretty good job of complementing the more theoretical RL course. 

 

# Conclusion 

Going into this Master's, I was expecting that the content would be a 50/50 split between math and computer science. Instead, I would say that the content was 99.9% math and theory oriented. However, I've quite enjoyed this, I feel like I've learned way more than I expected, and I've come out on the other side with a much deeper grasp of Machine Learning. Despite some rough edges, most of the courses were quite competently run and covered a range of interesting and relevant topics. Finally, the master's is challenging in terms of the difficulty and volume of information and the amount of coursework we needed to complete. Now that I’ve finished finals, I'll be working on my thesis over the summer, and I'll be hoping to put everything I learned into practice. 

 

 

 

 
