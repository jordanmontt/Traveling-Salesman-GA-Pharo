Class {
	#name : #GeneticAlgorithmConfigurator,
	#superclass : #Object,
	#instVars : [
		'crossProbability',
		'mutationProbability',
		'convergencePercentage',
		'initialPopulationSize'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #accessing }
GeneticAlgorithmConfigurator >> convergencePercentage [

	^ convergencePercentage
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> convergencePercentage: anObject [

	convergencePercentage := anObject
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> crossProbability [

	^ crossProbability
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> crossProbability: anObject [

	crossProbability := anObject
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> initialPopulationSize [

	^ initialPopulationSize
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> initialPopulationSize: anObject [

	initialPopulationSize := anObject
]

{ #category : #initialization }
GeneticAlgorithmConfigurator >> initialize [

	crossProbability := 0.7.
	mutationProbability := 0.001.
	convergencePercentage := 1.0.
	initialPopulationSize := 1000
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> mutationProbability [

	^ mutationProbability
]

{ #category : #accessing }
GeneticAlgorithmConfigurator >> mutationProbability: anObject [

	mutationProbability := anObject
]
