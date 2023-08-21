Class {
	#name : #TravelingSalesmanChromosome,
	#superclass : #Chromosome,
	#instVars : [
		'chromosome',
		'fitnessValue',
		'distance',
		'distancesMatrix'
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

	^ 11
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
TravelingSalesmanChromosome >> calculateDistance [

	distance := 0.
	1 to: chromosome size - 1 do: [ :i |
		distance := distance
			+ (self getDistanceOf: (chromosome at: i) and: (chromosome at: i + 1)) ].
	^ distance
]

{ #category : #defaults }
TravelingSalesmanChromosome >> calculateFitness [

	^ 60 - self distance
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
	l2 := random nextInteger: chromosomeCopy size ] doWhileTrue: [ "The +1 is because Pharo's collections start at 1"
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
TravelingSalesmanChromosome >> distance [

	^ distance ifNil: [ distance := self calculateDistance ]
]

{ #category : #accessing }
TravelingSalesmanChromosome >> distancesMatrix [
	^ distancesMatrix
]

{ #category : #accessing }
TravelingSalesmanChromosome >> fitness [

	^ fitnessValue ifNil: [ fitnessValue := self calculateFitness ]
]

{ #category : #defaults }
TravelingSalesmanChromosome >> getDistanceOf: a and: b [

	| startingValue |
	"Collections  indeces start in 1"
	startingValue := $A asciiValue - 1.
	^ (distancesMatrix at: a asciiValue - startingValue) at: b asciiValue - startingValue
]

{ #category : #initialization }
TravelingSalesmanChromosome >> initialize [

	super initialize.
	distancesMatrix := {
		             { 0. 5. 9. 1. 8. 5. 1. 4. 4. 2 }.
		             { 5. 0. 8. 6. 7. 4. 2. 6. 5. 3 }.
		             { 9. 8. 0. 4. 2. 6. 3. 5. 2. 1 }.
		             { 1. 6. 4. 0. 3. 5. 5. 3. 3. 4 }.
		             { 8. 7. 2. 3. 0. 4. 2. 2. 4. 2 }.
		             { 5. 4. 6. 5. 4. 0. 5. 3. 2. 3 }.
		             { 1. 2. 3. 5. 2. 5. 0. 1. 4. 4 }.
		             { 4. 6. 5. 3. 2. 3. 1. 0. 3. 5 }.
		             { 4. 5. 2. 3. 4. 2. 4. 3. 0. 3 }.
		             { 2. 3. 1. 4. 2. 3. 4. 5. 3. 0 } }
]

{ #category : #api }
TravelingSalesmanChromosome >> mutate [
	"Swap chromosome at a random position"

	| random positionToMutate temp |
	random := Random new.
	positionToMutate := (random nextInteger: self class chromosomeSize - 3) + 1.
	temp := chromosome at: positionToMutate.
	chromosome at: positionToMutate put: (chromosome at: positionToMutate + 1).
	chromosome at: positionToMutate + 1 put: temp
]

{ #category : #printing }
TravelingSalesmanChromosome >> printOn: aStream [

	aStream << self chromosomeString << ' fitness: ' << self fitness asString
	<< ' distance: ' << self distance asString
]

{ #category : #removing }
TravelingSalesmanChromosome >> removeHomeCity: aChromosome [
	"The home city is always at the start and the end"

	^ aChromosome copyFrom: 2 to: chromosome size - 1
]
