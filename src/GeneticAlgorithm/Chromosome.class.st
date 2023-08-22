"
I am a chromosome used for the SimpleGeneticAlgorithm. You need to subclass me and implement the missing methods.

Basically, you need to implement how I can random generate an individual, how to cross two individuals, how to mutate me, and how to calculate my fitness function
"
Class {
	#name : #Chromosome,
	#superclass : #Object,
	#instVars : [
		'fitnessValue'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
Chromosome class >> generateRandomIndividual [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Chromosome >> calculateFitness [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Chromosome >> cross: anotherChromosome [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Chromosome >> fitness [

	^ fitnessValue ifNil: [ fitnessValue := self calculateFitness ]
]

{ #category : #'as yet unclassified' }
Chromosome >> mutate [

	self subclassResponsibility
]
