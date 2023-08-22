Class {
	#name : #Chromosome,
	#superclass : #Object,
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #'as yet unclassified' }
Chromosome >> cross: anotherChromosome [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Chromosome >> fitness [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
Chromosome >> mutate [

	self subclassResponsibility
]
