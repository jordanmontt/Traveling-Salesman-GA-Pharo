Class {
	#name : #TravelingSalesmanChromosomeTest,
	#superclass : #TestCase,
	#instVars : [
		'travelingSalesmanProblem'
	],
	#category : #'GeneticAlgorithm-Tests-Tests'
}

{ #category : #tests }
TravelingSalesmanChromosomeTest >> calculateDistance: travelingSalesmanChromosome [

	| distance startingValue chromosomeString distancesMatrix |
	chromosomeString := travelingSalesmanChromosome chromosomeString.
	distancesMatrix := TravelingSalesmanProblem new distancesMatrix.
	distance := 0.
	startingValue := $A asciiValue - 1.

	1 to: travelingSalesmanChromosome chromosomeSize - 1 do: [ :i |
		| a b |
		a := (chromosomeString at: i) asciiValue - startingValue.
		b := (chromosomeString at: i + 1) asciiValue - startingValue.
		distance := distance + ((distancesMatrix at: a) at: b) ].
	^ distance
]

{ #category : #running }
TravelingSalesmanChromosomeTest >> setUp [

	super setUp.

	travelingSalesmanProblem := TravelingSalesmanProblem new
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateFitness [

	| travelingSalesmanChromosome distance chromosomeString |
	chromosomeString := 'ABCDEFGHIJA'.
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: chromosomeString.
	distance := 38.

	self assert: travelingSalesmanChromosome calculateFitness
		equals: travelingSalesmanProblem maximumDistance + 2 - distance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateTotalDistance [

	| travelingSalesmanChromosome |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ABCDEFGHIJA'.
	self assert: travelingSalesmanChromosome calculateTotalDistance equals: 38
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateTotalDistanceMax [

	| travelingSalesmanChromosome |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ACBHJDFGIEA'.

	self
		assert: travelingSalesmanChromosome calculateTotalDistance
		equals: travelingSalesmanProblem maximumDistance
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCalculateTotalDistanceMin [

	| travelingSalesmanChromosome |
	travelingSalesmanChromosome := TravelingSalesmanChromosome chromosome: 'ADEHFICJBGA'.
	self assert: travelingSalesmanChromosome calculateTotalDistance equals: 20
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testCross [

	| chromosomeOne chromosomeTwo child |
	chromosomeOne := TravelingSalesmanChromosome generateRandomIndividual.
	chromosomeTwo := TravelingSalesmanChromosome generateRandomIndividual.
	child := chromosomeOne cross: chromosomeTwo.

	"It must start and end in the initial city"
	self assert: child chromosomeString first equals: $A.
	self assert: child chromosomeString last equals: $A.
	"It must have the all the other cities"
	self assertCollection: (child chromosomeString copyFrom: 2 to: child chromosomeString size - 1) hasSameElements: 'BCDEFGHIJ'
]

{ #category : #tests }
TravelingSalesmanChromosomeTest >> testGenerateRandomIndividual [

	| travelingSalesmanChromosome chromosomeString |
	travelingSalesmanChromosome := TravelingSalesmanChromosome generateRandomIndividual.
	chromosomeString := travelingSalesmanChromosome chromosomeString.

	self assert: chromosomeString size equals: travelingSalesmanChromosome chromosomeSize.

	"It must start and end in the initial city"
	self assert: chromosomeString first equals: $A.
	self assert: chromosomeString last equals: $A.
	"It must have the all the other cities"

	self assertCollection: (chromosomeString copyFrom: 2 to: chromosomeString size - 1)
		hasSameElements: 'BCDEFGHIJ'
]
