"
I am an implementation of a Simple Genetic algorithm. I use the roulette Wheel Selection (https://en.wikipedia.org/wiki/Fitness_proportionate_selection) as the algorithm for randomly choosing the crossing individuals.

For using me, you need to subclass the class Chromosome and implement the missing methods.
"
Class {
	#name : #SimpleGeneticAlgorithm,
	#superclass : #Object,
	#instVars : [
		'population',
		'random',
		'generations',
		'configurator'
	],
	#category : #'GeneticAlgorithm-Core'
}

{ #category : #accessing }
SimpleGeneticAlgorithm >> configurator [

	^ configurator
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> createMapHowManyTimesFitnessAppears [
	"This is the same as doing `(population collect: #fitness) asBag` and then ask for the
	values, for example with `aBag valuesAndCounts values`. But this implementation is faster."

	| fitnessFrequency |
	fitnessFrequency := Dictionary new.
	population do: [ :individual |
		fitnessFrequency at: individual fitness update: [ :value | value + 1 ] initial: [ 1 ] ].
	^ fitnessFrequency
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> doesItConverge [

	| elementsThatMustHaveTheSameFitnessValue fitnessFrequency |
	elementsThatMustHaveTheSameFitnessValue := (population size * configurator convergencePercentage) asInteger.
	fitnessFrequency := self createMapHowManyTimesFitnessAppears.
	fitnessFrequency valuesDo: [ :timesTheFitnessValueAppears |
		timesTheFitnessValueAppears >= elementsThatMustHaveTheSameFitnessValue ifTrue: [
			"A fitness has appeared the required number of times"
			^ true ] ].
	^ false
]

{ #category : #api }
SimpleGeneticAlgorithm >> evolve [

	| descendants rouletteWheelSelection  doesConverge numberOfCrosses father mother childOne childTwo |
	population := self generatePopulation.
	descendants := OrderedCollection empty.
	rouletteWheelSelection := OrderedCollection empty.
	generations := 0.
	doesConverge := false.

	[ doesConverge ] whileFalse: [
		descendants removeAll.
		numberOfCrosses := configurator initialPopulationSize * configurator crossProbability / 2.
		
		"the indidividuals with a better fitness function will be more likely to be chosen"
		rouletteWheelSelection := self rouletteWheelSelection.

		[ numberOfCrosses = 0 ] whileFalse: [
			"Select randomly the two individuals that will cross"
			father := rouletteWheelSelection at: (random nextInteger: rouletteWheelSelection size).
			mother := rouletteWheelSelection at: (random nextInteger: rouletteWheelSelection size).

			"Cross the individuals and obtain their descendants"
			childOne := father cross: mother.
			childTwo := mother cross: father.

			"Mutate the descendants"
			childOne := self mutate: childOne.
			childTwo := self mutate: childTwo.

			"Insert childre into the descendants population"
			descendants add: childOne.
			descendants add: childTwo.

			numberOfCrosses := numberOfCrosses - 1 ].

		"Join old population (population) with the new population (descendants)"
		population addAll: descendants.
		population := self reducePopulation.
		generations := generations + 1.
		doesConverge := self doesItConverge ].

	"Return the best chromosome. Population is already sorted"
	^ population first
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> generatePopulation [

	population := (1 to: configurator initialPopulationSize)
		collect: [ :i | TravelingSalesmanChromosome generateRandomIndividual ]
		as: OrderedCollection.
	^ population
]

{ #category : #accessing }
SimpleGeneticAlgorithm >> generations [

	^ generations
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> hasToMutate [

	| probability randomNumber |
	probability := self mutationIntegerProbability.
	randomNumber := random nextInteger: probability.
	"Arbitrary number. The probability is number between 1 and 1000"
	^ randomNumber = 10
]

{ #category : #initialization }
SimpleGeneticAlgorithm >> initialize [

	super initialize.

	random := Random new.
	configurator := GeneticAlgorithmConfigurator new.
	generations := 0
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> mutate: individual [

	self hasToMutate ifTrue: [ individual mutate ].
	^ individual
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> mutationIntegerProbability [

	| probability aux |
	probability := 1.
	aux := configurator mutationProbability.
	[ aux < 1 ] whileTrue: [
		probability := probability * 10.
		aux := aux * 10.0 ].
	probability := probability / aux.
	^ probability
]

{ #category : #accessing }
SimpleGeneticAlgorithm >> population [

	^ population
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> reducePopulation [

	| reducedPopulation sortedPopulation |
	reducedPopulation := OrderedCollection empty.
	"the higher fitness is the best"
	sortedPopulation := population sorted: [ :o1 :o2 | o2 fitness < o1 fitness ].
	population := sortedPopulation first: configurator initialPopulationSize.
	^ population
]

{ #category : #defaults }
SimpleGeneticAlgorithm >> rouletteWheelSelection [
	"https://en.wikipedia.org/wiki/Fitness_proportionate_selection"

	| flatteredPopulation |
	flatteredPopulation := OrderedCollection empty.
	population do: [ :individual |
		individual fitness timesRepeat: [ flatteredPopulation add: individual ] ].
	^ flatteredPopulation
]