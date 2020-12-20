'From Cuis 5.0 [latest update: #4488] on 20 December 2020 at 9:34:22 pm'!
'Description '!
!provides: 'Spacewar!!' 1 79!
SystemOrganization addCategory: 'Spacewar!!'!


!classDefinition: #Mobile category: 'Spacewar!!'!
MovableMorph subclass: #Mobile
	instanceVariableNames: 'acceleration color velocity'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'Mobile class' category: 'Spacewar!!'!
Mobile class
	instanceVariableNames: 'vertices'!

!classDefinition: #SpaceShip category: 'Spacewar!!'!
Mobile subclass: #SpaceShip
	instanceVariableNames: 'name fuel torpedoes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceShip class' category: 'Spacewar!!'!
SpaceShip class
	instanceVariableNames: ''!

!classDefinition: #Torpedo category: 'Spacewar!!'!
Mobile subclass: #Torpedo
	instanceVariableNames: 'lifeSpan'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'Torpedo class' category: 'Spacewar!!'!
Torpedo class
	instanceVariableNames: ''!

!classDefinition: #SpaceWar category: 'Spacewar!!'!
MovableMorph subclass: #SpaceWar
	instanceVariableNames: 'color ships torpedoes centralStar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceWar class' category: 'Spacewar!!'!
SpaceWar class
	instanceVariableNames: ''!

!classDefinition: #CentralStar category: 'Spacewar!!'!
Morph subclass: #CentralStar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'CentralStar class' category: 'Spacewar!!'!
CentralStar class
	instanceVariableNames: ''!


!Mobile commentStamp: 'hlsf 10/25/2020 09:16:19' prior: 0!
An abstract mobile with a mass and inner acceleration, subject to a gravity pull.!

!SpaceShip commentStamp: 'hlsf 10/25/2020 09:19:28' prior: 0!
A ship comes with a torpedo inventory and a fuel tank.
Player controls its heading and acceleration, and he can fire torpedo.!

!Torpedo commentStamp: 'hlsf 10/25/2020 09:18:37' prior: 0!
A torpedo comes with a lifespan and an automatic acceleration handling!

!SpaceWar commentStamp: 'hlsf 11/1/2020 10:06:46' prior: 0!
I am the view and controler of the game.
My submorphs are the elements of the game.

To start the game execute: "SpaceWar new openInWorld"

Ship Controls
Green: left, right, up down arrows
Red: a, d, w, s keys!

!CentralStar commentStamp: '<historical>' prior: 0!
I am the central start of the game generating a gravity field.!

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

!Mobile methodsFor: 'geometry testing' stamp: 'hlsf 12/15/2020 21:03:38'!
requiresVectorCanvas
	^false! !

!Mobile methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 08:37:29'!
initialize
	super initialize.
	color _ Color gray.
	velocity _ 0 @ 0.
	acceleration _ 0.! !

!Mobile methodsFor: 'testing' stamp: 'hlsf 10/8/2020 22:21:33'!
isGoingOuterSpace
"is the mobile going crazy in direction of the outer space?"
	^ (self morphPosition dotProduct: velocity) > 0 ! !

!Mobile methodsFor: 'testing' stamp: 'hlsf 10/8/2020 22:21:40'!
isInOuterSpace
"Is the mobile located in the outer space? (outside of the game play area)"
	^(owner morphContainsPoint: self morphPosition) not! !

!Mobile methodsFor: 'drawing' stamp: 'hlsf 12/20/2020 13:20:13'!
drawOn: canvas polygon: vertices
	| size |
	size _ vertices size.
	vertices withIndexDo: [: aPoint :i |
		canvas line: aPoint to: ( vertices at: (i  \\ size + 1) ) width: 2 color: color]! !

!Mobile class methodsFor: 'as yet unclassified' stamp: 'hlsf 12/19/2020 23:21:09'!
vertices
	^ vertices ! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 12/15/2020 21:06:01'!
morphExtent

	^20@30! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 12/19/2020 14:27:34'!
fireTorpedo
"Fire a torpedo in the direction of the ship heading with a combined velocity"
	| torpedo | 
	torpedoes isZero ifTrue: [ ^ self].
	torpedoes _ torpedoes - 1.
	torpedo _ Torpedo new.
	torpedo 
		morphPosition: self morphPosition + self nose;
		rotation: location radians;
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

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 12/20/2020 15:18:30'!
drawOn: canvas
	| vertices  |
	vertices _ self class vertices.
	super drawOn: canvas polygon: vertices.
	"Draw gas exhaust"
	acceleration ifNotZero: [
		canvas line: vertices third to: 0@35 width: 1 color: Color gray].! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 12/15/2020 21:16:09'!
nose
	^ self direction * 40! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 12/19/2020 22:15:45'!
initialize
	super initialize.
	vertices _ {0@ -15 . -10@15. 0@ 10. 10@15}.
	self resupply! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 10/1/2020 17:30:57'!
resupply
	fuel _ 500.
	torpedoes _ 20! !

!SpaceShip class methodsFor: 'as yet unclassified' stamp: 'hlsf 12/19/2020 23:21:16'!
initialize
"SpaceShip initialize"
	vertices _ {0@-15 . -10@15. 0@10. 10@15}! !

!Torpedo methodsFor: 'computing' stamp: 'hlsf 12/19/2020 14:29:52'!
update: t
"Update the torpedo position"
	super update: t.
	"orientate the torpedo in its velocity direction, nicer effect while inaccurate"
	self rotation: (velocity y arcTan: velocity x) + Float halfPi.
	lifeSpan _ lifeSpan - 1.
	lifeSpan isZero ifTrue: [owner destroyTorpedo: self].
	acceleration > 0 ifTrue: [acceleration _ acceleration - 1000].! !

!Torpedo methodsFor: 'drawing' stamp: 'hlsf 12/20/2020 13:19:16'!
drawOn: canvas
	self drawOn: canvas polygon: self class vertices! !

!Torpedo methodsFor: 'geometry' stamp: 'hlsf 12/15/2020 21:06:53'!
morphExtent
	^ 4 @ 8! !

!Torpedo methodsFor: 'initialization' stamp: 'hlsf 12/15/2020 21:12:29'!
initialize
	super initialize.
	lifeSpan _ 500.
	acceleration _ 3000! !

!Torpedo class methodsFor: 'as yet unclassified' stamp: 'hlsf 12/19/2020 23:21:22'!
initialize
"Torpedo initialize"
	vertices _ {0@-4 . -2@4 . 2@4}! !

!SpaceWar methodsFor: 'accessing' stamp: 'jmv 9/28/2020 10:41:48'!
morphExtent
	^500@500! !

!SpaceWar methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 16:41:40'!
starMass
	^ centralStar mass! !

!SpaceWar methodsFor: 'actions' stamp: 'hlsf 9/21/2020 20:56:33'!
addTorpedo: aTorpedo
	torpedoes add: aTorpedo.
	self addMorph: aTorpedo ! !

!SpaceWar methodsFor: 'actions' stamp: 'hlsf 9/21/2020 21:10:33'!
destroyTorpedo: aTorpedo
	aTorpedo delete.
	torpedoes remove: aTorpedo ! !

!SpaceWar methodsFor: 'actions' stamp: 'hlsf 10/1/2020 17:29:37'!
teleport: aShip
"Teleport a ship at a random location"
	| area randomCoordinate |
	aShip resupply.
	area _ self morphLocalBounds insetBy: 20.
	randomCoordinate _ [(area left to: area right) atRandom].
	aShip 
		velocity: 0@0;
		morphPosition: randomCoordinate value @ randomCoordinate value! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 10/1/2020 15:04:27'!
collisions
	self collisionsShipsStar.
	self collisionsTorpedoesStar.
	self collisionsShipsTorpedoes.
	self collisionsShips ! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 12/15/2020 21:10:22'!
collisionsShips
	(ships first displayBounds intersects: ships second displayBounds) 		ifTrue: [
		ships do: [:each |
			each flashWith: Color red.
			self teleport: each]		]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 12/15/2020 20:46:09'!
collisionsShipsStar
	ships do: [:aShip | 
		(aShip displayBounds intersects: centralStar displayBounds) 		ifTrue: [
			aShip flashWith: Color red.
			self teleport: aShip]]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 12/15/2020 21:10:58'!
collisionsShipsTorpedoes
	ships do: [:aShip | 
		torpedoes do: [:aTorpedo |
		(aShip displayBounds intersects: aTorpedo displayBounds) 		ifTrue: [
			aShip flashWith: Color red.
			aTorpedo flashWith: Color orange.
			self destroyTorpedo: aTorpedo.
			self teleport: aShip]]
	]! !

!SpaceWar methodsFor: 'collisions' stamp: 'hlsf 12/15/2020 21:11:28'!
collisionsTorpedoesStar
	torpedoes do: [:each | 
		(each displayBounds intersects: centralStar displayBounds) 		ifTrue: [
			each flashWith: Color orange.
			self destroyTorpedo: each]]! !

!SpaceWar methodsFor: 'drawing' stamp: 'hlsf 10/1/2020 15:45:54'!
drawOn: aCanvas
	aCanvas
		fillRectangle: self morphLocalBounds
		color: color! !

!SpaceWar methodsFor: 'event handling testing' stamp: 'hlsf 11/1/2020 10:03:57'!
handlesKeyboard
	^ true! !

!SpaceWar methodsFor: 'event handling testing' stamp: 'hlsf 11/1/2020 10:04:18'!
handlesMouseOver: event
	^ true! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 10/25/2020 09:11:55'!
keyStroke: event
	| key |
	key _ event keyCharacter.
	key = Character arrowUp ifTrue: [^ ships first push].
	key = Character arrowRight ifTrue: [^ ships first right].
	key = Character arrowLeft ifTrue: [^ ships first left].
	key = Character arrowDown ifTrue: [^ ships first fireTorpedo].
	key = $w ifTrue: [^ ships second push].
	key =$d ifTrue: [^ ships second right].
	key = $a ifTrue: [^ ships second left].
	key = $s ifTrue: [^ ships second fireTorpedo]! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/11/2020 10:07:17'!
mouseEnter: evt
	evt hand newKeyboardFocus: self.	
	self startStepping! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/11/2020 10:07:22'!
mouseLeave: evt
	evt hand releaseKeyboardFocus: self.
	self stopStepping! !

!SpaceWar methodsFor: 'focus handling' stamp: 'hlsf 9/10/2020 16:04:35'!
keyboardFocusChange: gotFocus
	gotFocus 
		ifTrue: [color _ self defaultColor ]
		ifFalse: [color _ self defaultColor alpha: 0.5].
	self redrawNeeded.! !

!SpaceWar methodsFor: 'geometry testing' stamp: 'hlsf 12/15/2020 21:03:32'!
requiresVectorCanvas
	^false! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 9/10/2020 15:21:22'!
defaultColor
	^ `Color black`! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 11/1/2020 10:04:39'!
initialize
"We want to capture keyboard and mouse events, 
start the game loop(step) and initialize the actors." 
	super initialize.
	color _ self defaultColor.
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

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 12/16/2020 19:45:30'!
stepAt: millisecondSinceLast
	ships do: [:each | each update: millisecondSinceLast / 1000 ].
	ships do: [:each | each unpush ].
	torpedoes do: [:each | each update: millisecondSinceLast / 1000 ].
	self collisions.
	self redrawNeeded 
! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/11/2020 13:19:07'!
stepTime
"millisecond"
	^ 20! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/10/2020 18:03:59'!
wantsSteps
	^ true! !

!SpaceWar methodsFor: 'as yet unclassified' stamp: 'hlsf 12/11/2020 13:00:49'!
clipsSubmorphs
	^ true! !

!CentralStar methodsFor: 'accessing' stamp: 'hlsf 10/8/2020 22:20:17'!
mass
	^ 8000! !

!CentralStar methodsFor: 'drawing' stamp: 'hlsf 12/15/2020 21:05:29'!
drawOn: canvas
	| radius |
	radius _ self morphExtent // 2.
	canvas ellipseCenterX: 0
		y:  0
		rx: radius x + (2 atRandom - 1)
		ry: radius y + (2 atRandom - 1)
		borderWidth: 3 
		borderColor: Color orange 
		fillColor: Color yellow ! !

!CentralStar methodsFor: 'geometry testing' stamp: 'hlsf 12/15/2020 21:03:47'!
requiresVectorCanvas
	^false! !

!CentralStar methodsFor: 'as yet unclassified' stamp: 'hlsf 12/15/2020 21:04:13'!
morphExtent
	^ `30 @ 30`! !
SpaceShip initialize!
Torpedo initialize!
