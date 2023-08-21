Class {
	#name : #TravelingSalesmanChromosomeTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCross [

	| chromosomeOne chromosomeTwo child |
	chromosomeOne := TravelingSalesmanChromosome generateRandomTraveler.
	chromosomeTwo := TravelingSalesmanChromosome generateRandomTraveler.
	child := chromosomeOne cross: chromosomeTwo.

	"It can not be exactly the same as any of the other chromosomes"
	"self denyCollection: child chromosome equals: chromosomeOne chromosome.
	self denyCollection: child chromosome equals: chromosomeTwo chromosome."

	"It must start and end in the initial city"
	self assert: child chromosomeString first equals: $A.
	self assert: child chromosomeString last equals: $A.
	"It must have the all the other cities"
	self assertCollection: (child chromosomeString copyFrom: 2 to: child chromosomeString size - 1) hasSameElements: 'BCDEFGHIJ'
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testFitness [

	| travelingSalesmanChromosome expectedFitness startingValue chromosomeString |
	chromosomeString := 'ABCDEFGHIJA'.
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: chromosomeString.

	expectedFitness := 0.
	startingValue := $A asciiValue - 1.
	1 to: TravelingSalesmanChromosome chromosomeSize - 1 do: [ :i |
		| a b |
		a := (chromosomeString at: i) asciiValue - startingValue.
		b := (chromosomeString at: i + 1) asciiValue - startingValue.
		expectedFitness := expectedFitness
			+ ((travelingSalesmanChromosome distances at: a) at: b) ].
	expectedFitness := 60 - expectedFitness.

	self assert: travelingSalesmanChromosome fitness equals: (60 - 38)
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testGenerateRandomTraveler [

	| travelingSalesmanChromosome |
	travelingSalesmanChromosome := TravelingSalesmanChromosome generateRandomTraveler.

	self assert: travelingSalesmanChromosome chromosomeString size equals: TravelingSalesmanChromosome chromosomeSize.
	
	"It must start and end in the initial city"
	self assert: travelingSalesmanChromosome chromosomeString first equals: $A.
	self assert: travelingSalesmanChromosome chromosomeString last equals: $A.
	"It must have the all the other cities"
	self assertCollection: (travelingSalesmanChromosome chromosomeString copyFrom: 2 to: travelingSalesmanChromosome chromosomeString size - 1 ) hasSameElements: 'BCDEFGHIJ'
]
