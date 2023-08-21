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
		individual := geneticAlgorithm iterate.
		roassal generation: geneticAlgorithm generations.
		roassal individual: individual 
		"text := individual chromosomeString , String cr , 'fitness: ' , individual fitness asString ."
		"roassal text: text" ]
]

{ #category : #layout }
GAPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight add: goButton expand: false) expand: false;
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
