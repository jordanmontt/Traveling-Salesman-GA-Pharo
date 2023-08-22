Class {
	#name : #TravelingSalesmanChromosome,
	#superclass : #Chromosome,
	#instVars : [
		'chromosome',
		'fitnessValue',
		'numberOfCities',
		'chromosomeSize',
		'totalDistance',
		'travelingSalesmanProblem'
	],
	#category : #GeneticAlgorithm
}

{ #category : #'as yet unclassified' }
TravelingSalesmanChromosome class >> chromosome: anOrderedCollectionOfCharacters [

	^ self new
		  chromosome: anOrderedCollectionOfCharacters;
		  yourself
]

{ #category : #'as yet unclassified' }
TravelingSalesmanChromosome class >> chromosomeSize [

	^ self numberOfCities + 1
]

{ #category : #'as yet unclassified' }
TravelingSalesmanChromosome class >> generateRandomTraveler [

	| city cities |
	city := $B asciiValue.
	cities := OrderedCollection new.
	self numberOfCities - 1 timesRepeat: [
		cities add: city asCharacter.
		city := city + 1 ].
	cities shuffle.
	cities addFirst: $A.
	cities add: $A.
	^ self chromosome: cities
]

{ #category : #'as yet unclassified' }
TravelingSalesmanChromosome class >> numberOfCities [

	^ 10
]

{ #category : #defaults }
TravelingSalesmanChromosome >> calculateFitness [
	"58 is the maximum distance. We add 2 for not having negative nunmbers"

	^ 60 - self totalDistance
]

{ #category : #defaults }
TravelingSalesmanChromosome >> calculateTotalDistance [

	totalDistance := 0.
	1 to: chromosome size - 1 do: [ :i |
		totalDistance := totalDistance
			+ (travelingSalesmanProblem getDistanceBetween: (chromosome at: i) and: (chromosome at: i + 1)) ].
	^ totalDistance
]

{ #category : #accessing }
TravelingSalesmanChromosome >> chromosome [

	^ chromosome
]

{ #category : #accessing }
TravelingSalesmanChromosome >> chromosome: aCollection [

	chromosome := aCollection asOrderedCollection
]

{ #category : #accessing }
TravelingSalesmanChromosome >> chromosomeString [

	^ String streamContents: [ :stream | chromosome do: [ :e | stream nextPut: e ] ]
]

{ #category : #api }
TravelingSalesmanChromosome >> cross: anotherChromosome [

	| random l1 l2 inferiorLimit superiorLimit anotherChromosomeCopy chromosomeCopy initialCity child |
	random := Random new.
	initialCity := chromosome first.
	chromosomeCopy := chromosome copy.
	anotherChromosomeCopy := anotherChromosome chromosome copy.
	chromosomeCopy := self removeHomeCity: chromosomeCopy.
	anotherChromosomeCopy := self removeHomeCity: anotherChromosomeCopy.

	[
	l1 := random nextInteger: chromosomeCopy size.
	l2 := random nextInteger: chromosomeCopy size ] doWhileTrue: [
		l2 = l1 | (l1 + l2 >= (chromosomeCopy size )) ].
	inferiorLimit := l1 min: l2.
	superiorLimit := l1 max: l2.
	
	child := OrderedCollection withAll: (Array new: chromosomeCopy size).
	inferiorLimit to: superiorLimit do: [ :i |
		child at: i put: (chromosomeCopy at: i).
		anotherChromosomeCopy remove: (child at: i) ].
	child := child collect: [ :molecule |
		molecule ifNil: [ anotherChromosomeCopy removeFirst ] ifNotNil: [ molecule ] ].
	
	child addFirst: initialCity.
	child add: initialCity.

	^ self class chromosome: child
]

{ #category : #accessing }
TravelingSalesmanChromosome >> fitness [

	^ fitnessValue ifNil: [ fitnessValue := self calculateFitness ]
]

{ #category : #initialization }
TravelingSalesmanChromosome >> initialize [

	super initialize.
	travelingSalesmanProblem := TravelingSalesmanProblem new.
	numberOfCities := self class numberOfCities.
	chromosomeSize := numberOfCities + 1
]

{ #category : #api }
TravelingSalesmanChromosome >> mutate [
	"Swap two chromosome elements at a random position"

	| random positionToMutate temp |
	random := Random new.
	"To not swap the initial city (the first and the last)"
	positionToMutate := (random nextInteger: chromosomeSize - 3) + 1.
	temp := chromosome at: positionToMutate.
	chromosome at: positionToMutate put: (chromosome at: positionToMutate + 1).
	chromosome at: positionToMutate + 1 put: temp
]

{ #category : #printing }
TravelingSalesmanChromosome >> printOn: aStream [

	aStream << self chromosomeString << ' fitness: ' << self fitness asString
	<< ' distance: ' << self totalDistance asString
]

{ #category : #removing }
TravelingSalesmanChromosome >> removeHomeCity: aChromosome [
	"The home city is always at the start and the end"

	^ aChromosome copyFrom: 2 to: chromosome size - 1
]

{ #category : #accessing }
TravelingSalesmanChromosome >> totalDistance [

	^ totalDistance ifNil: [ totalDistance := self calculateTotalDistance ]
]
