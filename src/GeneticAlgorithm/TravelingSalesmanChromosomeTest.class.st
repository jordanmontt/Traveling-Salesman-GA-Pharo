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

	| distance startingValue chromosomeString distancesMatrix |
	chromosomeString := travelingSalesmanChromosome chromosomeString.
	distancesMatrix := TravelingSalesmanProblem new distancesMatrix.
	distance := 0.
	startingValue := $A asciiValue - 1.

	1 to: TravelingSalesmanChromosome chromosomeSize - 1 do: [ :i |
		| a b |
		a := (chromosomeString at: i) asciiValue - startingValue.
		b := (chromosomeString at: i + 1) asciiValue - startingValue.
		distance := distance + ((distancesMatrix at: a) at: b) ].
	^ distance
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
TravelingSalesmanChromosomeTest >> testCalculateTotalDistance [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ABCDEFGHIJA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateTotalDistance equals: expectedDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateTotalDistanceMax [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ACBHJDFGIEA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateTotalDistance equals: expectedDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateTotalDistanceMin [

	| travelingSalesmanChromosome expectedDistance |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ADEHFICJBGA'.
	expectedDistance := self calculateDistance: travelingSalesmanChromosome.
	self assert: travelingSalesmanChromosome calculateTotalDistance equals: expectedDistance
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

	| travelingSalesmanChromosome chromosomeString |
	travelingSalesmanChromosome := TravelingSalesmanChromosome generateRandomTraveler.
	chromosomeString := travelingSalesmanChromosome chromosomeString.

	self assert: chromosomeString size equals: TravelingSalesmanChromosome chromosomeSize.

	"It must start and end in the initial city"
	self assert: chromosomeString first equals: $A.
	self assert: chromosomeString last equals: $A.
	"It must have the all the other cities"

	self assertCollection: (chromosomeString copyFrom: 2 to: chromosomeString size - 1)
		hasSameElements: 'BCDEFGHIJ'
]
