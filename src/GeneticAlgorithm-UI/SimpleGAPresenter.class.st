Class {
	#name : #SimpleGAPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal',
		'goButton',
		'geneticAlgorithm'
	],
	#category : #'GeneticAlgorithm-UI'
}

{ #category : #'instance creation' }
SimpleGAPresenter class >> open [

	<script>
	^ self new open
]

{ #category : #initialization }
SimpleGAPresenter >> connectPresenters [

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
SimpleGAPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight add: goButton) expand: false;
		  add: roassal;
		  yourself
]

{ #category : #initialization }
SimpleGAPresenter >> initialize [

	super initialize.
	geneticAlgorithm := SimpleGeneticAlgorithm new.
	geneticAlgorithm generatePopulation
]

{ #category : #initialization }
SimpleGAPresenter >> initializePresenters [

	roassal := self instantiate: GARoassalPresenter.
	goButton := self newButton
		            label: 'Next generation';
		            iconName: #smallDoIt;
		            yourself
]

{ #category : #initialization }
SimpleGAPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Traveling Salesman Genetic Algoritm';
		initialExtent: 600 @ 500
]
