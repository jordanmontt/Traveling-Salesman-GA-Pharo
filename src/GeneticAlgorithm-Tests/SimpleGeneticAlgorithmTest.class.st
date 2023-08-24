"
A GeneticAlgorithmTest is a test class for testing the behavior of GeneticAlgorithm
"
Class {
	#name : #SimpleGeneticAlgorithmTest,
	#superclass : #TestCase,
	#instVars : [
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-Tests-Tests'
}

{ #category : #running }
SimpleGeneticAlgorithmTest >> setUp [

	super setUp.

	geneticAlgorithm := SimpleGeneticAlgorithm new
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testDoesItConverge [

	| population populationSize convergenceRate |
	populationSize := 1000.
	convergenceRate := 0.8. "80%"
	population := OrderedCollection empty.

	geneticAlgorithm configurator convergenceRate: convergenceRate.

	"Add 80% of equal chromosomes"
	population addAll: ((1 to: populationSize * convergenceRate) collect: [ :i |
		TravelingSalesmanChromosome chromosome: 'ABCDEFGHIJA' ]).
	"The rest different individuals with different fitness function"
	population addAll: ((1 to: populationSize * (1 - convergenceRate)) collect: [ :i |
		TravelingSalesmanChromosome generateRandomIndividual ]).
	
	geneticAlgorithm population: population.

	"It should converge as we have 80% of individuals with the same fitness function"
	self assert: geneticAlgorithm doesItConverge.
	
	geneticAlgorithm configurator convergenceRate: 0.9.
	self deny: geneticAlgorithm doesItConverge
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testGeneratePopulation [

	| population |
	population := geneticAlgorithm generatePopulation.
	self assert: population size equals: geneticAlgorithm configurator initialPopulationSize.
	population do: [ :individual |
		self assert: individual class equals: TravelingSalesmanChromosome ]
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testMutationIntegerProbability [

	geneticAlgorithm configurator mutationProbability: 0.0002.
	self assert: geneticAlgorithm mutationIntegerProbability equals: 5000
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testRouletteWheelSelection [

	| chromosomes population frequencies |
	chromosomes := #( 'ABCDEFJHIJA' 'AIHJEDBFCGA' 'ABFCJGEHIDA' ).
	population := chromosomes collect: [ :e | TravelingSalesmanChromosome chromosome: e ].
	geneticAlgorithm population: population.
	frequencies := geneticAlgorithm rouletteWheelSelection asBag.
	self assert: geneticAlgorithm rouletteWheelSelection size equals: frequencies size.
	population do: [ :individual |
		self assert: (frequencies valuesAndCounts at: individual) equals: individual fitness ]
]

{ #category : #tests }
SimpleGeneticAlgorithmTest >> testRun [

	| solution |
	geneticAlgorithm configurator convergenceRate: 1.0.
	solution := geneticAlgorithm run.
	self assert: solution fitness equals: 40.
	self assert: solution totalDistance equals: 20.
	self assert: geneticAlgorithm generations < 50
]
