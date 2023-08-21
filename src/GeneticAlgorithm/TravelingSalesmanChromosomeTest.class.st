Class {
	#name : #TravelingSalesmanChromosomeTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests'
}

{ #category : #tests }
TravelingSalesmanChromosomeTest >> calculateDistance: travelingSalesmanChromosome [

	| distance startingValue chromosomeString |
	chromosomeString := travelingSalesmanChromosome chromosomeString.
	distance := 0.
	startingValue := $A asciiValue - 1.
	1 to: TravelingSalesmanChromosome chromosomeSize - 1 do: [ :i |
		| a b |
		a := (chromosomeString at: i) asciiValue - startingValue.
		b := (chromosomeString at: i + 1) asciiValue - startingValue.
		distance := distance
			+ ((travelingSalesmanChromosome distancesMatrix at: a) at: b) ].
	^ distance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateDistance [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ABCDEFGHIJA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateDistance equals: expectedDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateDistanceMax [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ACBHJDFGIEA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateDistance equals: expectedDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateDistanceMin [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ADEHFICJBGA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateDistance equals: expectedDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateFitness [

	| travelingSalesmanChromosome distance chromosomeString |
	chromosomeString := 'ABCDEFGHIJA'.
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: chromosomeString.
	distance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateFitness equals: 60 - distance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCross [

	| chromosomeOne chromosomeTwo child |
	chromosomeOne := TravelingSalesmanChromosome generateRandomTraveler.
	chromosomeTwo := TravelingSalesmanChromosome generateRandomTraveler.
	child := chromosomeOne cross: chromosomeTwo.

	"It must start and end in the initial city"
	self assert: child chromosomeString first equals: $A.
	self assert: child chromosomeString last equals: $A.
	"It must have the all the other cities"
	self assertCollection: (child chromosomeString copyFrom: 2 to: child chromosomeString size - 1) hasSameElements: 'BCDEFGHIJ'
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
