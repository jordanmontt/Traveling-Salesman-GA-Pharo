# Traveling-Salesman-GA-Pharo

This repository contains an implementation of the Traveling Salesman Problem (TSP) solved using a Genetic Algorithm (GA) in the Pharo programming language. The solution is built using object-oriented programming (OOP) patterns and clean code principles, and it includes a user interface for interacting with and inspecting the algorithm.

_Java implementation available at: https://github.com/jordanmontt/Traveling-Salesman-GA_

## Introduction

The Traveling Salesman Problem (TSP) is a classic optimization problem where the goal is to find the shortest possible route that visits each city exactly once and returns to the origin city. This repository provides a solution to the TSP using a Genetic Algorithm implemented in Pharo.

Features:

- Genetic Algorithm implementation for solving TSP.
- Written in Pharo, a dynamic and reflective pure object-oriented language.
- Easy to extend and modify for different TSP instances.
- User interface for interacting with and inspecting the algorithm.
- Comprehensive test suite.

## Preview

![Enregistrementdelecran2025-02-16a00 57 22-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/5fa9febb-7e61-48bf-8079-b4841078faf9)

## Implementation Details

### Genetic Algorithm

The problem is solved using a simple Genetic Algorithm. The key components of the implementation are:

- Chromosome Representation: The TSP is modeled as a collection of chromosomes, where each chromosome represents a possible route.
- Selection: The roulette wheel selection algorithm is used for the random selection of chromosomes. This method ensures that chromosomes with higher fitness values have a greater chance of being selected.
- Crossover and Mutation: Standard genetic operators are used to create new generations of chromosomes.
- Fitness Evaluation: The fitness of each chromosome is evaluated based on the total distance of the route it represents.

### Object-Oriented Design

The implementation follows object-oriented programming principles and clean code practices. The code is modular, with clear separation of concerns, making it easy to understand and maintain.

### User Interface

The project includes a graphical user interface (UI) built in Pharo. The UI allows users to interact with the algorithm, visualize the progress of the genetic algorithm, and inspect the results.

### Testing

The repository includes several tests to ensure the correctness of the implementation. The tests cover various aspects of the genetic algorithm, including selection, crossover, mutation, and fitness evaluation.
