Class {
	#name : #BaselineOfSimpleGeneticAlgorithm,
	#superclass : #BaselineOf,
	#category : #'BaselineOfGeneticAlgorithm-Baseline'
}

{ #category : #baselines }
BaselineOfSimpleGeneticAlgorithm >> baseline: spec [

	<baseline>
	spec for: #common do: [
		"Packages"
		spec package: 'GeneticAlgorithm'.
		spec package: 'GeneticAlgorithm-UI' with: [ spec requires: #( 'GeneticAlgorithm' ) ].
		spec package: 'GeneticAlgorithm-Tests' with: [ spec requires: #( 'GeneticAlgorithm' ) ].

		"Loading Roassal for Pharo 10 and 11"
		spec for: #( #'pharo10.x' #'pharo11.x' ) do: [
			spec baseline: 'Roassal3'
				with: [ spec repository: 'github://ObjectProfile/Roassal3:v1.01/src' ].
			spec package: 'GeneticAlgorithm-UI' with: [ spec requires: #( 'Roassal3' ) ] ].

		"Groups"
		spec group: 'default' with: #( 'core' 'tests' ).
		spec group: 'core' with: #( 'GeneticAlgorithm' 'GeneticAlgorithm-UI' ).
		spec group: 'tests' with: #( 'GeneticAlgorithm-Tests' ) ]
]
