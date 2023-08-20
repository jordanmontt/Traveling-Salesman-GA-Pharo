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
