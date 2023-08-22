Class {
	#name : #GAPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal',
		'goButton',
		'geneticAlgorithm'
	],
	#category : #GeneticAlgorithm
}

{ #category : #initialization }
GAPresenter >> connectPresenters [

	goButton action: [
		| individual |
		geneticAlgorithm iterate.
		individual := geneticAlgorithm population atRandom.
		roassal
			generation: geneticAlgorithm generations;
			hasConverged: geneticAlgorithm doesItConverge;
			individual: individual;
			refresh ]
]

{ #category : #layout }
GAPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight add: goButton) expand: false;
		  add: roassal;
		  yourself
]

{ #category : #initialization }
GAPresenter >> initialize [

	super initialize.
	geneticAlgorithm := GeneticAlgorithm new.
	geneticAlgorithm generatePopulation
]

{ #category : #initialization }
GAPresenter >> initializePresenters [

	roassal := self instantiate: GARoassalPresenter.
	goButton := self newButton
		            label: 'Next generation';
		            iconName: #smallDoIt;
		            yourself
]

{ #category : #initialization }
GAPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Traveling Salesman Genetic Algoritm';
		initialExtent: 600 @ 500
]

{ #category : #api }
GAPresenter >> iterate [

	| descendants rouletteWheelSelection numberOfCrosses father mother descendantOne descendantTwo |
	descendants := OrderedCollection empty.
	rouletteWheelSelection := OrderedCollection empty.

	"number of crosses is calculated according to cross probability"
	numberOfCrosses := initialPopulationSize * crossProbability / 2.
	rouletteWheelSelection := self rouletteWheelSelection.

	[ numberOfCrosses = 0 ] whileFalse: [
		"Select the two individuals that will cross"
		father := rouletteWheelSelection at: (random nextInteger: rouletteWheelSelection size).
		mother := rouletteWheelSelection at: (random nextInteger: rouletteWheelSelection size).

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
	population := self reducePopulation.
	generations := generations + 1.

	"Return the best chromosome FOR THIS ITERATION. Population is already sorted"
	^ population first
]
