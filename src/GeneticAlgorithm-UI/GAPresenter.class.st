Class {
	#name : #GAPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal',
		'goButton',
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-UI'
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
	geneticAlgorithm := SimpleGeneticAlgorithm new.
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
