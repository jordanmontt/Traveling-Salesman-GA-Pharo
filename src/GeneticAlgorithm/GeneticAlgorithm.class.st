Class {
	#name : #GeneticAlgorithm,
	#superclass : #Object,
	#instVars : [
		'populationSize',
		'crossProbability',
		'chromosomeSize',
		'mutationProbability',
		'convergencePercentage',
		'numberOfCities',
		'distances'
	],
	#category : #GeneticAlgorithm
}

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> createLife [

	| population descendants rouletteWheelSelection random skewedRouletteLength generations doesConverge numberOfCrosses father mother crossResult descendantOne descendantTwo |
	population := self generatePopulation.
	descendants := OrderedCollection empty.
	rouletteWheelSelection := OrderedCollection empty.
	random := Random new.
	skewedRouletteLength := 0.
	generations := 0.
	doesConverge := false.

	[ doesConverge ] whileFalse: [
		descendants removeAll.
		"number of crosses is calculated according to cross probability"
		numberOfCrosses := populationSize * crossProbability / 2.
		rouletteWheelSelection := self rouletteWheelSelection: population.
		skewedRouletteLength := rouletteWheelSelection size.

		[ numberOfCrosses = 0 ] whileFalse: [
			"Select the two individuals that will cross"
			father := rouletteWheelSelection at: (random nextInteger: skewedRouletteLength).
			mother := rouletteWheelSelection at: (random nextInteger: skewedRouletteLength).

			"Cross the individuals"
			crossResult := self cross: father with: mother.

			"Obtain their descendants"
			descendantOne := crossResult first.
			descendantTwo := crossResult second.

			"Mutate the descendants"
			descendantOne := self mutate: descendantOne.
			descendantTwo := self mutate: descendantTwo.

			"Insert the descendants into the descenders population"
			descendants add: descendantOne -> (self fitness: descendantOne).
			descendants add: descendantTwo -> (self fitness: descendantTwo).

			numberOfCrosses := numberOfCrosses - 1 ].

		"Join old population (population) with the new population (descendants)"
		population addAll: descendants.
		population := self reducePopulation: population.
		generations := generations + 1.
		(self doesItConverge: population) ifTrue: [ doesConverge := true ] ].

	('Generaciones necesarias: ' , generations asString) traceCr.
	(population first key asString , '=' , (60 - population first value) asString) traceCr.

	"Return the best chromosome"
	self halt.
	^ population max: #value
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> createMapWithHowManyTimeFitnessAppears: population [
	"Dictionary (fitnessValue -> number of times the fitness value appears)"

	| fitnessFrequency |
	fitnessFrequency := Dictionary new.
	population do: [ :individual |
		fitnessFrequency at: individual value update: [ :value | value + 1 ] initial: [ 1 ] ].
	^ fitnessFrequency
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> cross: father with: mother [

	| descendants |
	descendants := OrderedCollection empty.
	descendants add: (self crossingFirstSon2: father mother: mother).
	descendants add: (self crossingSecondSon2: father mother: mother).
	^ descendants
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> crossingFirstSon2: father mother: mother [

	| random l1 l2 inferiorLimit superiorLimit motherAsAList fatherAsAList initialCity firstSon |
	random := Random new.
	fatherAsAList := father asOrderedCollection.
	motherAsAList := mother asOrderedCollection.
	initialCity := fatherAsAList first.
	fatherAsAList := self removeHomeCity: fatherAsAList.
	motherAsAList := self removeHomeCity: motherAsAList.

	[
	l1 := random nextInteger: fatherAsAList size.
	l2 := random nextInteger: fatherAsAList size ] doWhileTrue: [
		l2 = l1 | ((l1 - l2) abs = fatherAsAList size) ].

	inferiorLimit := l1 min: l2.
	superiorLimit := l1 max: l2.

	firstSon := OrderedCollection withAll: (Array new: chromosomeSize).
	firstSon at: 1 put: initialCity.
	firstSon at: chromosomeSize put: initialCity.
	inferiorLimit to: superiorLimit do: [ :i |
		firstSon at: i + 1 put: (fatherAsAList at: i).
		motherAsAList remove: (firstSon at: i + 1) ifAbsent: [ ] ].
	firstSon := firstSon collect: [ :molecule |
		            molecule ifNil: [ fatherAsAList removeFirst ] ifNotNil: [ molecule ] ].
	^ String streamContents: [ :stream | firstSon do: [ :e | stream nextPut: e ] ]
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> crossingSecondSon [
	"(String father, String mother)"
	"
        List<Character> fatherAsAList = father.chars().mapToObj(e -> (char) e).collect(Collectors.toList());
        List<Character> motherAsAList = mother.chars().mapToObj(e -> (char) e).collect(Collectors.toList());
        char[] secondSon = new char[CHROMOSOME_SIZE];
        int secondSonLimit, isPair = 0;
        char firstCity = father.charAt(0);
        fatherAsAList = removeHomeCity(fatherAsAList);
        motherAsAList = removeHomeCity(motherAsAList);

        secondSon[0] = firstCity;
        secondSon[CHROMOSOME_SIZE - 1] = firstCity;

        secondSon[CHROMOSOME_SIZE - 2] = fatherAsAList.get(fatherAsAList.size() - 1);
        fatherAsAList.remove(fatherAsAList.size() - 1);

        if (secondSon[CHROMOSOME_SIZE - 2] == motherAsAList.get(motherAsAList.size() - 2)) {
            secondSon[CHROMOSOME_SIZE - 4] = motherAsAList.get(motherAsAList.size() - 3);
            motherAsAList.remove(motherAsAList.size() - 3);
            fatherAsAList.remove(new Character(secondSon[CHROMOSOME_SIZE - 4]));

            secondSon[CHROMOSOME_SIZE - 3] = fatherAsAList.get(fatherAsAList.size() - 1);
            fatherAsAList.remove(fatherAsAList.size() - 1);
            motherAsAList.remove(new Character(secondSon[CHROMOSOME_SIZE - 3]));
            secondSonLimit = CHROMOSOME_SIZE - 4;
        } else {
            secondSon[CHROMOSOME_SIZE - 3] = motherAsAList.get(motherAsAList.size() - 2);
            motherAsAList.remove(motherAsAList.size() - 2);
            fatherAsAList.remove(new Character(secondSon[CHROMOSOME_SIZE - 3]));
            secondSonLimit = CHROMOSOME_SIZE - 3;
        }
        motherAsAList.remove(new Character(secondSon[CHROMOSOME_SIZE - 2]));

        for (int i = 1; i < secondSonLimit; i++) {
            if (isPair % 2 == 0) {
                secondSon[i] = fatherAsAList.get(0);
                fatherAsAList.remove(0);
                motherAsAList.remove(new Character(secondSon[i]));
            } else {
                secondSon[i] = motherAsAList.get(0);
                motherAsAList.remove(0);
                fatherAsAList.remove(new Character(secondSon[i]));
            }
            isPair++;
        }
        return new String(secondSon);"
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> crossingSecondSon2: father mother: mother [

	| l1 l2 inferiorLimit superiorLimit random initialCity fatherAsAList motherAsAList firstSon |
	random := Random new.
	initialCity := father first.
	fatherAsAList := father asOrderedCollection.
	motherAsAList := mother asOrderedCollection.
	fatherAsAList := self removeHomeCity: fatherAsAList.
	motherAsAList := self removeHomeCity: motherAsAList.

	[
	l1 := random nextInteger: fatherAsAList size.
	l2 := random nextInteger: fatherAsAList size ] doWhileTrue: [
		l2 = l1 | ((l1 - l2) abs = fatherAsAList size) ].

	inferiorLimit := l1 min: l2.
	superiorLimit := l1 max: l2.
	firstSon := OrderedCollection withAll: (Array new: chromosomeSize).
	firstSon at: 1 put: initialCity.
	firstSon at: chromosomeSize put: initialCity.

	inferiorLimit to: superiorLimit do: [ :i |
		firstSon at: i + 1 put: (motherAsAList at: i).
		fatherAsAList remove: (firstSon at: i + 1) ifAbsent: [ ] ].
	firstSon := firstSon collect: [ :molecule |
		molecule ifNil: [ fatherAsAList removeFirst ] ifNotNil: [ molecule ] ].
	^ String streamContents: [ :stream | firstSon do: [ :e | stream nextPut: e ] ]
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> doesItConverge: population [

	| elementsThatMustHaveTheSameFitnessValue fitnessFrequency |
	elementsThatMustHaveTheSameFitnessValue := (population size * convergencePercentage) asInteger.
	fitnessFrequency := self createMapWithHowManyTimeFitnessAppears: population.
	fitnessFrequency valuesDo: [ :timesTheFitnessValueAppears |
		timesTheFitnessValueAppears >= elementsThatMustHaveTheSameFitnessValue ifTrue: [
			"A fitness has appeared the required number of times"
			^ true ] ].
	^ false
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> fitness: chromosome [

	| fit |
	fit := 0.
	1 to: chromosome size - 1 do: [ :i |
	fit := fit + (self getDistance: (chromosome at: i) with: (chromosome at: i + 1)) ].
	^ 60 - fit
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> generatePopulation [

	| population indivudual |
	population := OrderedCollection empty.
	[ population size <= populationSize ] whileTrue: [
		indivudual := self generateRandomTravel.
		population add: indivudual -> (self fitness: indivudual) ].
	^ population
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> generateRandomTravel [

	| city cities |
	city := $B asciiValue.
	cities := OrderedCollection new.
	numberOfCities - 1 timesRepeat: [
		cities add: city asCharacter.
		city := city + 1 ].
	cities shuffle.
	cities addFirst: $A.
	cities add: $A.
	^ String streamContents: [ :stream | cities do: [ :e | stream nextPut: e ] ]
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> getDistance: a with: b [

	| startingValue |
	"Collections  indeces start in 1"
	startingValue := $A asciiValue - 1.
	^ (distances at: a asciiValue - startingValue) at: b asciiValue - startingValue
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> hasToMutate [

	| random probability randomNumber |
	random := Random new.
	probability := self probabilityAsInteger.
	randomNumber := random nextInteger: probability.
	"arbitrary number. because the probability is number between 1 and 1000"
	^ randomNumber = 10
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> initialize [

	super initialize.

	crossProbability := 0.7.
	mutationProbability := 0.001.
	convergencePercentage := 1.0.
	populationSize := 1000.
	numberOfCities := 10.
	chromosomeSize := numberOfCities + 1.
	distances := {
		             { 0. 5. 9. 1. 8. 5. 1. 4. 4. 2 }.
		             { 5. 0. 8. 6. 7. 4. 2. 6. 5. 3 }.
		             { 9. 8. 0. 4. 2. 6. 3. 5. 2. 1 }.
		             { 1. 6. 4. 0. 3. 5. 5. 3. 3. 4 }.
		             { 8. 7. 2. 3. 0. 4. 2. 2. 4. 2 }.
		             { 5. 4. 6. 5. 4. 0. 5. 3. 2. 3 }.
		             { 1. 2. 3. 5. 2. 5. 0. 1. 4. 4 }.
		             { 4. 6. 5. 3. 2. 3. 1. 0. 3. 5 }.
		             { 4. 5. 2. 3. 4. 2. 4. 3. 0. 3 }.
		             { 2. 3. 1. 4. 2. 3. 4. 5. 3. 0 } }
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> mutate: state [

	self hasToMutate ifTrue: [ self swapArrayAtRandomPosition: state ].
	^ state
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> probabilityAsInteger [

	| probability aux |
	probability := 1.
	aux := mutationProbability.
	[ aux < 1 ] whileTrue: [
		probability := probability * 10.
		aux := aux * 10.0 ].
	probability := probability / aux.
	^ probability
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> reducePopulation: population [

	| reducedPopulation sortedPopulation |
	reducedPopulation := OrderedCollection empty.
	"the lower fitness is the best"
	"population.sort((o1, o2) -> (o2.getValue().compareTo(o1.getValue())));"
	sortedPopulation := population sorted: [ :o1 :o2 | o2 value < o1 value ].
	reducedPopulation := sortedPopulation first: populationSize.
	^ reducedPopulation
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> removeHomeCity: chromosome [

	^ chromosome copyFrom: 2 to: chromosome size - 1
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> rouletteWheelSelection: population [

	| flatteredPopulation |
	flatteredPopulation := OrderedCollection empty.
	population do: [ :individual |
		individual value timesRepeat: [ flatteredPopulation add: individual key ] ].
	self haltIf: [ flatteredPopulation size = 0 ].
	^ flatteredPopulation
]

{ #category : #'as yet unclassified' }
GeneticAlgorithm >> swapArrayAtRandomPosition: state [

	| random positionToMutate temp |
	random := Random new.
	positionToMutate := (random nextInteger: chromosomeSize - 3) + 1.
	temp := state at: positionToMutate.
	state at: positionToMutate put: (state at: positionToMutate + 1).
	state at: positionToMutate + 1 put: temp.
	^ state
]
