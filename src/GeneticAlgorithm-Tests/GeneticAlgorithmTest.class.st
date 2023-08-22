"
A GeneticAlgorithmTest is a test class for testing the behavior of GeneticAlgorithm
"
Class {
	#name : #GeneticAlgorithmTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests-Tests'
}

{ #category : #running }
GeneticAlgorithmTest >> setUp [

	super setUp.

	geneticAlgorithm := SimpleGeneticAlgorithm new
]

{ #category : #tests }
GeneticAlgorithmTest >> testEvolve [

	| solution |
	solution := geneticAlgorithm evolve.
	self assert: solution fitness equals: 40.
	self assert: solution totalDistance equals: 20.
	self assert: geneticAlgorithm generations < 50
]

{ #category : #tests }
GeneticAlgorithmTest >> testGeneratePopulation [

	| population |
	population := geneticAlgorithm generatePopulation.
	self assert: population size equals: geneticAlgorithm configurator initialPopulationSize.
	population do: [ :individual |
		self assert: individual class equals: TravelingSalesmanChromosome ]
]
