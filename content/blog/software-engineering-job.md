---
title: "Finding success as a Software Engineer"
subtitle: "Pursue to be a good software engineer and a successful career will follow."
date: 2023-03-12T12:08:36-07:00
draft: false
series:
- career advice
- Samyak
featuredImage: images/software-engineering.jpg
featuredImageCaption: Photo by <a href="https://unsplash.com/@wocintechchat?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Christina @ wocintechchat.com</a> on <a href="https://unsplash.com/photos/8S6BkMGaLyQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
---

<!-- TOC -->
* [Yet another post for programming career.](#yet-another-post-for-programming-career)
    * [Software engineering interviews are broken.](#software-engineering-interviews-are-broken)
    * [Cracking the interview does not mean you are a good engineer](#cracking-the-interview-does-not-mean-you-are-a-good-engineer)
* [How to start](#how-to-start)
  * [Generalize and not specialize!](#generalize-and-not-specialize-)
    * [Networking](#networking)
    * [Lower level Systems](#lower-level-systems)
    * [System design](#system-design)
    * [Databases](#databases)
* [Deciding on a programming language](#deciding-on-a-programming-language)
  * [Programming paradigm](#programming-paradigm)
  * [Object-oriented programming](#object-oriented-programming)
  * [Functional programming](#functional-programming)
  * [Verdict](#verdict)
* [Practice](#practice)
<!-- TOC -->

Learning to build software is something that anyone can pick up at any point in their career. This is one of the fields that can be easy to understand, i.e., you don't need to start learning and honing your skills from childhood. Programming and building software can be learned in months and is a career path people choose from all walks of life. But taking that first step can be challenging, especially now because of the recent turmoil in the world economy and job market. Let's look at what it takes for someone new to programming to get a job as a software engineer.

# Yet another post for programming career.

There are tons of articles, blog posts, youtube videos, etc., explaining how to land a job in software engineering. Although they help, it takes work to excel once you get a job. This is because of several reasons:

### Software engineering interviews are broken.
This is common knowledge that the software engineering interview process needs to be fixed. Candidates are asked how to build Linked Lists, trees, traversing graphs, etc. Yes, these data structures are the building blocks of software. Still, in most cases, data structures are abstracted remarkably optimally. Asking an experienced engineer how to delete a node in a binary tree wastes time for the candidate and the interviewer.

### Cracking the interview does not mean you are a good engineer
Interview questions usually include a [coding problem from leetcode](https://leetcode.com) or a design question where the candidate is asked to design a software system. Candidates are suggested to solve as many problems as possible before they come in for the interview, which puts fundamental problem-solving skills on the back burner.
At its core, **software engineering is the epitome of problem-solving**. Most of the time, an engineer is working on how to solve simple problems on the scale, which an interviewer needs to be able to properly assess.

# How to start

## Generalize and not specialize!
When someone starts learning about programming and building software, people often make a mistake by beginning from learning a programming language. A programming language is just a tool in your arsenal to solve problems. When preparing for an engineering job, brush up on the basics first. Nowadays, some programming languages are better at some use cases than others. Picking up a programming language because of its popularity might take you down a path you would not look forward to.

### Networking
- [What happens when you type in `google.com` on your browser and press enter?](https://github.com/alex/what-happens-when) 
- [How does a data packet flow on the internet?](https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web/How_the_Web_works)
- What are different internet protocols?
  - [TCP/IP](https://www.ibm.com/docs/en/aix/7.2?topic=protocol-tcpip-protocols)
  - [HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
  - [DNS/ARP](/blog/how-does-dns-work/)

### Lower level Systems
- [Linux operating system](https://ubuntu.com/tutorials/command-line-for-beginners#1-overview)
- [File systems](https://opensource.com/life/16/10/introduction-linux-filesystems)
- [Commands](https://developers.redhat.com/cheat-sheets/linux-commands-cheat-sheet-old)
- [Containerization](/blog/containers)

### System design
- [Distributed systems](https://www.confluent.io/learn/distributed-systems/)
- API Design
  - [REST API](https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design)
  - [GraphQL](https://graphql.org/learn/)
- [Caching](https://aws.amazon.com/caching/)

### Databases
- [Relational Databases (SQL databases)](https://cloud.google.com/learn/what-is-a-relational-database)
- [Non-relational databases (NoSQL databases)](https://www.mongodb.com/databases/non-relational)

Understanding the above topics makes it much easier to grasp in-and-out of any programming language.

# Deciding on a programming language
Now that we have learned the basics, it is time to start learning a programming language. Selecting a programming language can be purely subjective based on the following decisions.  

## Programming paradigm
A programming paradigm explains how a programming language can create software. The type of programming paradigm a language follows can help us understand the features the language provides and how it can be used to implement solutions and create software.
Multiple programming paradigms exist, but functional and object-oriented programming paradigms are the most commonly used. Let's explore what they are:

## Object-oriented programming
- Object-oriented programming is creating computer programs based on real-world objects, including creating a class that acts as a blueprint or a definition of things or objects.
- A general rule of thumb for defining what would be a class and what would be an object can be tangibility. If it's intangible, like a car, book, etc., then it's a class. A car or book is intangible, but, `Honda Accord` and `Harry Potter and the Prisoner of Azkaban` are tangible objects created from the blueprints of car and book.
- A class defines an object's properties and what an object can do. Let's take an example, imagine implementing a library management solution. In this case, we can create a book as a class. A book can have properties like title, number of pages, author, etc., and actions like borrowed, released, archived, etc.
- As it is evident object-oriented programming does an exceptional job of creating software that requires modeling real-world entities.
- Some examples of object-oriented languages are Java, Ruby, Python, C++, C#, etc.

Learn more about Object-oriented programming here -  https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Objects/Object-oriented_programming.

## Functional programming
- A functional programming language is based on functions which are blocks of code that take in some data, perform processing of the input and return an output based on processing.
- An essential aspect of functional programming is that input data in the function arguments is not changed, i.e., the input is immutable.
- Functional programming functions are considered individual entities and can be regarded as data.
- Some examples of functional-oriented programming languages are Python, Ruby, Javascript, Golang, etc.
- As seen, languages like Python and Ruby are flexible and mature enough to support both object-oriented and functional programming paradigms.

As it can be seen languages like Python and Ruby are flexible and mature enough that they can support both object-oriented and functional programming paradigms.

## Verdict
As a beginner, consider learning a language like Python.
- Python is flexible enough to support use cases like web development, scripting, data engineering, etc.
- Python is easy to set up and has extensive documentation.
- Python is loosely typed, which can help beginners focus on their application logic than their programming flow.

> **Note:** Remember, this verdict is subjective. As discussed in the previous sections, a big part of this decision depends on what you are trying to develop. Other languages, like Ruby, Javascript, Java, etc., are also viable options.

# Practice
Start building small projects like a simple web application or a sudoku game. Leetcode can also be an excellent point for starting up the language basics. Still, since leetcode questions are small, it does not involve planning and designing for the big picture, which can only be learned through creating small projects. This is what differentiates a programmer and a software engineer. Creating a solution for a particular problem, like in leetcode, is a different ballgame than making an extensive application and learning how to scale it and troubleshoot it.
Remember, software engineering involves problem-solving at its finest. It does not matter if you are a junior engineer or a distinguished engineer; this branch of engineering is evolving so quickly that every engineer is learning.
