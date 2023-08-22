"
A GeneticAlgorithmTest is a test class for testing the behavior of GeneticAlgorithm
"
Class {
	#name : #SimpleGeneticAlgorithmTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests-Tests'
}

{ #category : #running }
SimpleGeneticAlgorithmTest >> setUp [

	super setUp.

	geneticAlgorithm := SimpleGeneticAlgorithm new
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testGeneratePopulation [

	| population |
	population := geneticAlgorithm generatePopulation.
	self assert: population size equals: geneticAlgorithm configurator initialPopulationSize.
	population do: [ :individual |
		self assert: individual class equals: TravelingSalesmanChromosome ]
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testRun [

	| solution |
	geneticAlgorithm configurator convergenceRate: 1.0.
	solution := geneticAlgorithm run.
	self assert: solution fitness equals: 40.
	self assert: solution totalDistance equals: 20.
	self assert: geneticAlgorithm generations < 50
]
