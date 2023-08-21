Class {
	#name : #GeneticAlgorithm,
	#superclass : #Object,
	#instVars : [
		'populationSize',
		'crossProbability',
		'chromosomeSize',
		'mutationProbability',
		'convergencePercentage',
		'numberOfCities',
		'distances'
	],
	#category : #GeneticAlgorithm
}

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> createLife [

	| population descendants rouletteWheelSelection random skewedRouletteLength generations doesConverge numberOfCrosses father mother descendantOne descendantTwo |
	population := self generatePopulation.
	descendants := OrderedCollection empty.
	rouletteWheelSelection := OrderedCollection empty.
	random := Random new.
	skewedRouletteLength := 0.
	generations := 0.
	doesConverge := false.

	[ doesConverge ] whileFalse: [
		descendants removeAll.
		"number of crosses is calculated according to cross probability"
		numberOfCrosses := populationSize * crossProbability / 2.
		rouletteWheelSelection := self rouletteWheelSelection: population.
		skewedRouletteLength := rouletteWheelSelection size.

		[ numberOfCrosses = 0 ] whileFalse: [
			"Select the two individuals that will cross"
			father := rouletteWheelSelection at: (random nextInteger: skewedRouletteLength).
			mother := rouletteWheelSelection at: (random nextInteger: skewedRouletteLength).

			"Cross the individuals and obtain their descendants"
			descendantOne := father cross: mother.
			descendantTwo := mother cross: father.

			"Mutate the descendants"
			descendantOne := self mutate: descendantOne.
			descendantTwo := self mutate: descendantTwo.

			"Insert the descendants into the descenders population"
			descendants add: descendantOne.
			descendants add: descendantTwo.

			numberOfCrosses := numberOfCrosses - 1 ].

		"Join old population (population) with the new population (descendants)"
		population addAll: descendants.
		population := self reducePopulation: population.
		generations := generations + 1.
		(self doesItConverge: population) ifTrue: [ doesConverge := true ] ].

	('Generaciones necesarias: ' , generations asString) traceCr.
	(population first chromosomeString asString , '=' , (60 - population first fitness) asString) traceCr.

	"Return the best chromosome"
	^ population max: #fitness
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> createMapWithHowManyTimeFitnessAppears: population [
	"Dictionary (fitnessValue -> number of times the fitness value appears)"

	| fitnessFrequency |
	fitnessFrequency := Dictionary new.
	population do: [ :individual |
		fitnessFrequency at: individual fitness update: [ :value | value + 1 ] initial: [ 1 ] ].
	^ fitnessFrequency
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> cross: father with: mother [

	| descendants |
	descendants := OrderedCollection empty.
	descendants add: (self crossingFirstSon2: father mother: mother).
	descendants add: (self crossingSecondSon2: father mother: mother).
	^ descendants
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> doesItConverge: population [

	| elementsThatMustHaveTheSameFitnessValue fitnessFrequency |
	elementsThatMustHaveTheSameFitnessValue := (population size * convergencePercentage) asInteger.
	fitnessFrequency := self createMapWithHowManyTimeFitnessAppears: population.
	fitnessFrequency valuesDo: [ :timesTheFitnessValueAppears |
		timesTheFitnessValueAppears >= elementsThatMustHaveTheSameFitnessValue ifTrue: [
			"A fitness has appeared the required number of times"
			^ true ] ].
	^ false
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> generatePopulation [

	| population indivudual |
	population := OrderedCollection empty.
	populationSize timesRepeat: [
		indivudual := TravelingSalesmanChromosome generateRandomTraveler.
		population add: indivudual ].
	^ population
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> hasToMutate [

	| random probability randomNumber |
	random := Random new.
	probability := self probabilityAsInteger.
	randomNumber := random nextInteger: probability.
	"arbitrary number. because the probability is number between 1 and 1000"
	^ randomNumber = 10
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> initialize [

	super initialize.

	crossProbability := 0.7.
	mutationProbability := 0.001.
	convergencePercentage := 1.0.
	populationSize := 1000.
	numberOfCities := 10.
	chromosomeSize := numberOfCities + 1.
	distances := {
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

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> mutate: individual [

	self hasToMutate ifTrue: [ individual mutate ].
	^ individual
]

{ #category : #accessing }
GeneticAlgorithm >> populationSize [

	^ populationSize
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> probabilityAsInteger [

	| probability aux |
	probability := 1.
	aux := mutationProbability.
	[ aux < 1 ] whileTrue: [
		probability := probability * 10.
		aux := aux * 10.0 ].
	probability := probability / aux.
	^ probability
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> reducePopulation: population [

	| reducedPopulation sortedPopulation |
	reducedPopulation := OrderedCollection empty.
	"the lower fitness is the best"
	"population.sort((o1, o2) -> (o2.getValue().compareTo(o1.getValue())));"
	sortedPopulation := population sorted: [ :o1 :o2 | o2 fitness < o1 fitness ].
	reducedPopulation := sortedPopulation first: populationSize.
	^ reducedPopulation
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> removeHomeCity: chromosome [

	^ chromosome copyFrom: 2 to: chromosome size - 1
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> rouletteWheelSelection: population [

	| flatteredPopulation |
	flatteredPopulation := OrderedCollection empty.
	population do: [ :individual |
		individual fitness timesRepeat: [ flatteredPopulation add: individual ] ].
	^ flatteredPopulation
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> swapArrayAtRandomPosition: state [

	| random positionToMutate temp |
	random := Random new.
	positionToMutate := (random nextInteger: chromosomeSize - 3) + 1.
	temp := state at: positionToMutate.
	state at: positionToMutate put: (state at: positionToMutate + 1).
	state at: positionToMutate + 1 put: temp.
	^ state
]
