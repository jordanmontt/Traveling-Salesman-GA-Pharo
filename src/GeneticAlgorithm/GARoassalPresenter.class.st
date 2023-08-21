Class {
	#name : #GARoassalPresenter,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'individual',
		'generation',
		'hasConverged'
	],
	#category : #GeneticAlgorithm
}

{ #category : #'as yet unclassified' }
GARoassalPresenter >> addLegend: canvas [

	| label |
	label := RSMultilineLabelBuilder new shapeFor: self legengText.
	label isFixed: true.
	RSHorizontalLineLayout on: { label }.
	canvas addShape: label
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> createEdges: nodes [

	| edges |
	edges := (1 to: nodes size - 1) collect: [ :i |
		         self makeLineFrom: (nodes at: i) to: (nodes at: i + 1) ]
		         as: OrderedCollection.
	edges add: (self makeLineFrom: nodes last to: nodes first).
	^ edges
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> createNodes [

	| nodes |
	nodes := RSComposite boxesForModels: individual chromosome allButLast.
	nodes first children first color: Color red.
	^ nodes
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> generation: anInteger [

	generation := anInteger
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> hasConverged: aBoolean [

	hasConverged := aBoolean
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> individual: anIndividual [

	individual := anIndividual
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> initialize [

	super initialize.
	self script: [ :canvas | self renderIn: canvas ]
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> legengText [

	^ 'Generation: ' , generation asString , String cr , 'Fitness: '
	  , individual fitness asString , String cr , 'Distance: ' , individual distance asString
	  , String cr , ' Has converged: ' , hasConverged asString
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> makeLayout: canvas [

	| forceBasedLayout |
	RSCircleLayout on: canvas nodes.

	forceBasedLayout := RSForceBasedLayout new
		                    length: 80;
		                    charge: -300;
		                    addNodes: canvas nodes;
		                    edges: OrderedCollection empty;
		                    alpha: 0.1;
		                    yourself.

	canvas lines do: [ :e |
		| mockedLine |
		mockedLine := (forceBasedLayout newMockLineFor: e) length: (e model * 15).
		forceBasedLayout edges add: mockedLine ].

	"forceBasedLayout start."
	canvas newAnimation repeat onStepDo: [ :t |
		forceBasedLayout step.
		canvas zoomToFit ].
	canvas nodes @ (RSDraggableForceInteraction new layout: forceBasedLayout)
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> makeLineFrom: a to: b [

	| distance |
	distance := individual getDistanceOf: a model and: b model.
	^ RSArrowedLine new
		  from: a;
		  to: b;
		  model: distance;
		  withBorderAttachPoint;
		  color: Color black;
		  yourself
]

{ #category : #'as yet unclassified' }
GARoassalPresenter >> renderIn: canvas [

	| nodes |
	individual ifNil: [ ^ self ].
	nodes := self createNodes.
	canvas addAll: nodes.
	canvas addAll: (self createEdges: nodes).

	self makeLayout: canvas.

	canvas @ RSCanvasController.
	self addLegend: canvas.
	"nodes @ RSDraggable"
]
