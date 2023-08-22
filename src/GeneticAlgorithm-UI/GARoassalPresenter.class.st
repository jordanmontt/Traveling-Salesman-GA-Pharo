Class {
	#name : #GARoassalPresenter,
	#superclass : #SpRoassalPresenter,
	#instVars : [
		'individual',
		'generation',
		'hasConverged'
	],
	#category : #'GeneticAlgorithm-UI'
}

{ #category : #roassal }
GARoassalPresenter >> addLegend: canvas [

	| label |
	label := RSMultilineLabelBuilder new shapeFor: self legengText.
	label isFixed: true.
	RSHorizontalLineLayout on: { label }.
	canvas addShape: label
]

{ #category : #roassal }
GARoassalPresenter >> createEdges: nodes [

	| edges |
	edges := (1 to: nodes size - 1) collect: [ :i |
		         self makeLineFrom: (nodes at: i) to: (nodes at: i + 1) ]
		         as: OrderedCollection.
	edges add: (self makeLineFrom: nodes last to: nodes first).
	^ edges
]

{ #category : #roassal }
GARoassalPresenter >> createNodes [

	| box boxes label nodes models |
	models := individual chromosome allButLast.
	boxes := (1 to: models size) collect: [ :i |
	box := RSBox new.
	box color: Color white.
	box border: (RSBorder new joinMiter; color: Color black) ].
	label := RSLabel new.
	label color: Color black.
	nodes := RSComposite models: models box: box label: label.
	
	nodes first children first color: Color red.
	^ nodes
]

{ #category : #accessing }
GARoassalPresenter >> generation: anInteger [

	generation := anInteger
]

{ #category : #accessing }
GARoassalPresenter >> hasConverged: aBoolean [

	hasConverged := aBoolean
]

{ #category : #accessing }
GARoassalPresenter >> individual: anIndividual [

	individual := anIndividual
]

{ #category : #initialization }
GARoassalPresenter >> initialize [

	super initialize.
	self script: [ :canvas | self renderIn: canvas ]
]

{ #category : #accessing }
GARoassalPresenter >> legengText [

	^ 'Generation: ' , generation asString , String cr , 'Fitness: '
	  , individual fitness asString , String cr , 'Distance: ' , individual totalDistance asString
	  , String cr , ' Has converged: ' , hasConverged asString
]

{ #category : #roassal }
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

{ #category : #roassal }
GARoassalPresenter >> makeLineFrom: a to: b [

	| distance |
	distance := individual getDistanceBetween: a model and: b model.
	^ RSArrowedLine new
		  from: a;
		  to: b;
		  model: distance;
		  withBorderAttachPoint;
		  color: Color black;
		  yourself
]

{ #category : #roassal }
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
