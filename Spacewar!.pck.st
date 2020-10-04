'From Cuis 5.0 [latest update: #4390] on 4 October 2020 at 4:32:15 pm'!
'Description '!
!provides: 'Spacewar!!' 1 65!
SystemOrganization addCategory: #'Spacewar!!'!


!classDefinition: #CentralStar category: #'Spacewar!!'!
Morph subclass: #CentralStar
	instanceVariableNames: 'mass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'CentralStar class' category: #'Spacewar!!'!
CentralStar class
	instanceVariableNames: ''!

!classDefinition: #Mobile category: #'Spacewar!!'!
Morph subclass: #Mobile
	instanceVariableNames: 'acceleration color velocity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'Mobile class' category: #'Spacewar!!'!
Mobile class
	instanceVariableNames: ''!

!classDefinition: #SpaceShip category: #'Spacewar!!'!
Mobile subclass: #SpaceShip
	instanceVariableNames: 'name fuel torpedoes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceShip class' category: #'Spacewar!!'!
SpaceShip class
	instanceVariableNames: ''!

!classDefinition: #Torpedo category: #'Spacewar!!'!
Mobile subclass: #Torpedo
	instanceVariableNames: 'lifeSpan'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'Torpedo class' category: #'Spacewar!!'!
Torpedo class
	instanceVariableNames: ''!

!classDefinition: #SpaceWar category: #'Spacewar!!'!
Morph subclass: #SpaceWar
	instanceVariableNames: 'color ships torpedoes centralStar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceWar class' category: #'Spacewar!!'!
SpaceWar class
	instanceVariableNames: ''!


!CentralStar commentStamp: '<historical>' prior: 0!
I am the central start of the game generating a gravity field.!

!SpaceWar commentStamp: 'hlsf 9/16/2020 15:06:56' prior: 0!
I am the gameplay view. My submorphs are the elements of the game.

| game | 
game _ SpaceWar new.
game addMorph: SpaceShip new.
game openInWorld

Control with the left, up, right arrows!

!CentralStar methodsFor: 'accessing' stamp: 'hlsf 9/10/2020 13:59:50'!
mass
	^ mass! !

!CentralStar methodsFor: 'drawing' stamp: 'hlsf 10/1/2020 15:43:23'!
drawOn: canvas
	canvas ellipseCenterX: 0
		y:  0
		rx: 15 + (2 atRandom - 1)
		ry: 15 + (2 atRandom - 1)
		borderWidth: 3 
		borderColor: Color orange 
		fillColor: Color yellow ! !

!CentralStar methodsFor: 'initialization' stamp: 'hlsf 9/16/2020 16:06:06'!
initialize
	super initialize.
	mass _ 8000.! !

!CentralStar methodsFor: 'geometry testing' stamp: 'jmv 9/28/2020 14:35:30'!
requiresVectorCanvas
	^false! !

!Mobile methodsFor: 'accessing' stamp: 'hlsf 10/1/2020 08:34:04'!
color: aColor
	"Set the receiver's color. "
	color = aColor ifFalse: [
		color _ aColor.
		self redrawNeeded ]! !

!Mobile methodsFor: 'accessing' stamp: 'hlsf 10/1/2020 09:12:27'!
direction
"I am an unit vector representing the noze direction of the mobile"
	^Point rho: 1 theta: location radians - Float halfPi! !

!Mobile methodsFor: 'accessing' stamp: 'hlsf 10/1/2020 08:34:23'!
mass
	^ 1! !

!Mobile methodsFor: 'accessing' stamp: 'hlsf 10/1/2020 12:18:54'!
velocity: aVector
	velocity _ 	aVector ! !

!Mobile methodsFor: 'computing' stamp: 'hlsf 10/1/2020 08:34:37'!
gravity
"Compute the gravity acceleration vector"
	| position |
	position _ self morphPosition.
	^ [-10 * self mass * owner starMass / (position r raisedTo: 3) * position]
		on: Error do: [0 @ 0]! !

!Mobile methodsFor: 'computing' stamp: 'hlsf 10/1/2020 09:12:07'!
update: t
"Update the mobile position and velocity "
	| ai ag newVelocity |
	"acceleration vectors"
	ai _ acceleration * self direction.
	ag _ self gravity.
	newVelocity _ (ai + ag) * t + velocity.
	self morphPosition: (0.5 * (ai + ag) * t squared) + (velocity * t) + self morphPosition.
	velocity _ newVelocity .
	
	"Are we out of screen?
	If so we move the mobile to the other corner and slow it down by a factor of 2"
	(self isInOuterSpace and: [self isGoingOuterSpace])
		ifTrue: [
			velocity _ velocity / 2.
			self morphPosition: self morphPosition negated]! !

!Mobile methodsFor: 'geometry testing' stamp: 'hlsf 10/1/2020 08:34:46'!
requiresVectorCanvas
	^false! !

!Mobile methodsFor: 'testing' stamp: 'hlsf 10/1/2020 09:11:27'!
isGoingOuterSpace
"is the mobile going crazy in the outer space?"
	^ (self morphPosition dotProduct: velocity) > 0 ! !

!Mobile methodsFor: 'testing' stamp: 'hlsf 10/1/2020 09:11:35'!
isInOuterSpace
"Is the mobile located in the outer space? (outside of the game playarea)"
	^(owner morphContainsPoint: self morphPosition) not! !

!Mobile methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 08:37:29'!
initialize
	super initialize.
	color _ Color gray.
	velocity _ 0 @ 0.
	acceleration _ 0.! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 10/1/2020 14:51:37'!
morphExtent

	^60@60! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 17:24:19'!
initialize
	super initialize.
	self resupply! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 17:30:57'!
resupply
	fuel _ 500.
	torpedoes _ 20! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 10/1/2020 18:11:26'!
drawOn: canvas

	| a b c d |
	a _ 0@ -30.
	b _ -10@0.
	c _ 0@ -5.
	d _ 10@0.
	canvas line: a to: b width: 2 color: color.
	canvas line: b to: c width: 2 color: color.
	canvas line: c to: d width: 2 color: color.
	canvas line: d to: a width: 2 color: color.

	"Draw gas exhaust"
	acceleration ifNotZero: [
		canvas line: c to: 0@20 width: 1 color: Color gray].! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 9/21/2020 20:47:48'!
nose

	^ self direction * 30! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 10/1/2020 17:25:38'!
fireTorpedo
"Fire a torpedo in the direction of the ship heading with a combined velocity"
	| torpedo | 
	torpedoes isZero ifTrue: [ ^ self].
	torpedoes _ torpedoes - 1.
	torpedo _ Torpedo new.
	torpedo 
		morphPosition: self morphPosition + self nose;
		rotateBy: location radians;
		velocity: velocity;
		color: color muchLighter .
	owner addTorpedo: torpedo.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:07:51'!
left
"Rotate the ship to its left"
	self rotateBy: -0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 10/1/2020 17:26:59'!
push
"Init an accelaration boost"
	fuel isZero ifTrue: [^ self].
	fuel _ fuel - 1.
	acceleration _ 50! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:01'!
right
"Rotate the ship to its right"
	self rotateBy: 0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:18'!
unpush
"Stop the accelaration boost"
	acceleration _ 0! !

!Torpedo methodsFor: 'computing' stamp: 'hlsf 10/2/2020 21:15:54'!
update: t
"Update the torpedo position"
	super update: t.
	"orientate the torpedo in its velocity direction, nicer effect while inaccurate"
	self rotation: (velocity y arcTan: velocity x) + Float halfPi scale: 1.
	lifeSpan _ lifeSpan - 1.
	lifeSpan isZero ifTrue: [owner destroyTorpedo: self].
	acceleration > 0 ifTrue: [acceleration _ acceleration - 1000].! !

!Torpedo methodsFor: 'drawing' stamp: 'hlsf 10/1/2020 08:38:35'!
drawOn: canvas

	| a b c |
	a _ 0@ -8.
	b _ -2@0.
	c _ 2@0.
	canvas line: a to: b width: 2 color: color.
	canvas line: c to: b width: 2 color: color.
	canvas line: a to: c width: 2 color: color.! !

!Torpedo methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 08:57:33'!
initialize
	super initialize.
	lifeSpan _ 500.
	acceleration _ 4000! !

!Torpedo methodsFor: 'geometry' stamp: 'hlsf 10/1/2020 14:52:01'!
morphExtent
	^ 8 @ 8! !

!SpaceWar methodsFor: 'accessing' stamp: 'jmv 9/28/2020 10:41:48'!
morphExtent
	^500@500! !

!SpaceWar methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 16:41:40'!
starMass
	^ centralStar mass! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 9/10/2020 15:21:22'!
defaultColor
	^ `Color black`! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 10/4/2020 15:36:42'!
initialize
"We want to capture keyboard and mouse events, 
start the game loop(step) and initialize the actors." 
	super initialize.
	color _ self defaultColor.
	self setProperty: #'handlesKeyboard' toValue: true.
	self setProperty: #'handlesMouseOver:' toValue: true.
	self startSteppingStepTime: self stepTime.
	self initializeActors.! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 10/3/2020 11:45:38'!
initializeActors
	centralStar _ CentralStar new.
	self addMorph: centralStar.
	centralStar morphPosition: 0@0.
	torpedoes _ OrderedCollection new.
	ships _ Array 		with: SpaceShip new 		with: SpaceShip new.
	self addAllMorphs: ships.
	ships first 
		morphPosition: 200 @ -200;
		color: Color green darker.
	ships second 
		morphPosition: -200 @ 200;
		color: Color red darker.! !

!SpaceWar methodsFor: 'drawing' stamp: 'hlsf 10/1/2020 15:45:54'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/21/2020 20:56:33'!
addTorpedo: aTorpedo
	torpedoes add: aTorpedo.
	self addMorph: aTorpedo ! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/21/2020 21:10:33'!
destroyTorpedo: aTorpedo
	aTorpedo delete.
	torpedoes remove: aTorpedo ! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 10/3/2020 15:22:00'!
keyStroke: event
	| key |
	key _ event keyCharacter.
	key = Character arrowUp ifTrue: [^ ships first push].
	key = Character arrowRight ifTrue: [^ ships first right].
	key = Character arrowLeft ifTrue: [^ ships first left].
	key = Character arrowDown ifTrue: [^ ships first fireTorpedo]! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/11/2020 10:07:17'!
mouseEnter: evt
	evt hand newKeyboardFocus: self.	
	self startStepping! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/11/2020 10:07:22'!
mouseLeave: evt
	evt hand releaseKeyboardFocus: self.
	self stopStepping! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 10/1/2020 17:29:37'!
teleport: aShip
"Teleport a ship at a random location"
	| area randomCoordinate |
	aShip resupply.
	area _ self morphLocalBounds insetBy: 20.
	randomCoordinate _ [(area left to: area right) atRandom].
	aShip 
		velocity: 0@0;
		morphPosition: randomCoordinate value @ randomCoordinate value! !

!SpaceWar methodsFor: 'focus handling' stamp: 'hlsf 9/10/2020 16:04:35'!
keyboardFocusChange: gotFocus
	gotFocus 
		ifTrue: [color _ self defaultColor ]
		ifFalse: [color _ self defaultColor alpha: 0.5].
	self redrawNeeded.! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 10/1/2020 14:38:36'!
stepAt: millisecondSinceLast
	ships do: [:each | each update: millisecondSinceLast / 1000 ].
	ships do: [:each | each unpush ].
	torpedoes do: [:each | each update: millisecondSinceLast / 1000 ].
	self collisions.
	self redrawNeeded ! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/11/2020 13:19:07'!
stepTime
"millisecond"
	^ 20! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/10/2020 18:03:59'!
wantsSteps
	^ true! !

!SpaceWar methodsFor: 'geometry testing' stamp: 'jmv 9/28/2020 14:35:47'!
requiresVectorCanvas
	^false! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 15:04:27'!
collisions
	self collisionsShipsStar.
	self collisionsTorpedoesStar.
	self collisionsShipsTorpedoes.
	self collisionsShips ! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 15:07:19'!
collisionsShips
	(ships first morphPosition dist: ships second morphPosition) < 25 		ifTrue: [
		ships do: [:each |
			each flashWith: Color red.
			self teleport: each]		]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 14:54:07'!
collisionsShipsStar
	ships do: [:aShip | 
		(aShip morphPosition dist: centralStar morphPosition) < 20 		ifTrue: [
			aShip flashWith: Color red.
			self teleport: aShip]]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 14:58:09'!
collisionsShipsTorpedoes
	ships do: [:aShip | 
		torpedoes do: [:aTorpedo |
		(aShip morphPosition dist: aTorpedo morphPosition) < 15 		ifTrue: [
			aShip flashWith: Color red.
			aTorpedo flashWith: Color orange.
			self destroyTorpedo: aTorpedo.
			self teleport: aShip]]
	]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 14:57:03'!
collisionsTorpedoesStar
	torpedoes do: [:each | 
		(each morphPosition dist: centralStar morphPosition) < 8 		ifTrue: [
			each flashWith: Color orange.
			self destroyTorpedo: each]]! !
