"
A GeneticAlgorithmTest is a test class for testing the behavior of GeneticAlgorithm
"
Class {
	#name : #GeneticAlgorithmTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #running }
GeneticAlgorithmTest >> setUp [

	super setUp.

	geneticAlgorithm := GeneticAlgorithm new
]

{ #category : #tests }
GeneticAlgorithmTest >> testCreateLife [

	geneticAlgorithm createLife
]

{ #category : #tests }
GeneticAlgorithmTest >> testGeneratePopulation [

	| population |
	population := geneticAlgorithm generatePopulation.
	self assert: population size equals: geneticAlgorithm populationSize.
	population do: [ :individual | self assert: individual chromosome isNotNil ]
]
