Class {
	#name : #SimpleGAPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'roassal',
		'geneticAlgorithm',
		'evolveButton',
		'inspectGA',
		'generatePopulationButton',
		'resetButton'
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

	evolveButton action: [
		| individual |
		
		geneticAlgorithm population ifNil: [ 
			
			self  ].
		
		geneticAlgorithm evolveOneGeneration.
		individual := geneticAlgorithm population atRandom.
		roassal
			geneticAlgorithm: geneticAlgorithm;
			individual: individual;
			refresh ].
	inspectGA action: [ geneticAlgorithm inspect ].
	generatePopulationButton action: [ geneticAlgorithm generatePopulation ].
	resetButton action: [
		geneticAlgorithm := SimpleGeneticAlgorithm new.
		roassal
			individual: nil;
			refresh ]
]

{ #category : #layout }
SimpleGAPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: evolveButton;
				   add: inspectGA;
				   add: generatePopulationButton;
				   add: resetButton;
				   yourself)
		  expand: false;
		  add: roassal;
		  yourself
]

{ #category : #initialization }
SimpleGAPresenter >> initialize [

	geneticAlgorithm := SimpleGeneticAlgorithm new.
	super initialize
]

{ #category : #initialization }
SimpleGAPresenter >> initializePresenters [

	roassal := self instantiate: GARoassalPresenter.
	evolveButton := self newButton
		                label: 'Evolve one generation';
		                iconName: #smallDoIt;
		                yourself.
	inspectGA := self newButton
		             label: 'Inspect';
		             iconName: #smallInspectIt;
		             yourself.
	generatePopulationButton := self newButton
		                            label: 'Generate population';
		                            iconName: #smallDoIt;
		                            yourself.
	resetButton := self newButton
		               label: 'Reset';
		               yourself
]

{ #category : #initialization }
SimpleGAPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Traveling Salesman Genetic Algoritm';
		initialExtent: 600 @ 500
]
