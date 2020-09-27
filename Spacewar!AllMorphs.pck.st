'From Cuis 5.0 [latest update: #4249] on 27 September 2020 at 2:51:28 pm'!
'Description '!
!provides: 'Spacewar!!AllMorphs' 1 24!
SystemOrganization addCategory: #'Spacewar!!AllMorphs'!


!classDefinition: #CentralStar category: #'Spacewar!!AllMorphs'!
EllipseMorph subclass: #CentralStar
	instanceVariableNames: 'mass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!AllMorphs'!
!classDefinition: 'CentralStar class' category: #'Spacewar!!AllMorphs'!
CentralStar class
	instanceVariableNames: ''!

!classDefinition: #SpaceWar category: #'Spacewar!!AllMorphs'!
SystemWindow subclass: #SpaceWar
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!AllMorphs'!
!classDefinition: 'SpaceWar class' category: #'Spacewar!!AllMorphs'!
SpaceWar class
	instanceVariableNames: ''!

!classDefinition: #GamePlay category: #'Spacewar!!AllMorphs'!
RectangleLikeMorph subclass: #GamePlay
	instanceVariableNames: 'ships torpedoes centralStar'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!AllMorphs'!
!classDefinition: 'GamePlay class' category: #'Spacewar!!AllMorphs'!
GamePlay class
	instanceVariableNames: 'timeLapse'!

!classDefinition: #SpaceShip category: #'Spacewar!!AllMorphs'!
RectangleLikeMorph subclass: #SpaceShip
	instanceVariableNames: 'name shape position heading velocity fuel torpedoes acceleration shipBounds'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!AllMorphs'!
!classDefinition: 'SpaceShip class' category: #'Spacewar!!AllMorphs'!
SpaceShip class
	instanceVariableNames: ''!

!classDefinition: #Torpedo category: #'Spacewar!!AllMorphs'!
SpaceShip subclass: #Torpedo
	instanceVariableNames: 'direction lifeSpan'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!AllMorphs'!
!classDefinition: 'Torpedo class' category: #'Spacewar!!AllMorphs'!
Torpedo class
	instanceVariableNames: ''!


!CentralStar commentStamp: '<historical>' prior: 0!
I am the central start of the game generating a gravity field.!

!GamePlay commentStamp: 'hlsf 9/16/2020 15:06:56' prior: 0!
I am the gameplay view. My submorphs are the elements of the game.

| game | 
game _ SpaceWar new.
game addMorph: SpaceShip new.
game openInWorld

Control with the left, up, right arrows!

!CentralStar methodsFor: 'accessing' stamp: 'hlsf 9/10/2020 13:59:50'!
mass
	^ mass! !

!CentralStar methodsFor: 'accessing' stamp: 'hlsf 9/10/2020 14:00:10'!
mass: anInteger
	mass _ anInteger ! !

!CentralStar methodsFor: 'initialization' stamp: 'hlsf 9/26/2020 17:08:38'!
initialize
	super initialize.
	color _ Color yellow.
	borderColor _ Color orange.
	borderWidth _ 2.
	mass _ 10000.! !

!CentralStar methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 11:29:05'!
step
	extent _  (20 + (4 atRandom - 1)) @ (20 + (4 atRandom - 1)).
	self morphPosition: owner morphExtent - extent // 2.! !

!CentralStar methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 11:35:20'!
stepTime
	^ 100! !

!CentralStar methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 13:43:14'!
wantsSteps
	^ true! !

!SpaceWar methodsFor: 'as yet unclassified' stamp: 'hlsf 9/27/2020 12:36:36'!
initialize
	super initialize.
	self setLabel: 'Spacewar!!'.
	self addMorph: GamePlay new layoutSpec: LayoutSpec useAll! !

!GamePlay methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 16:41:40'!
starMass
	^ centralStar mass! !

!GamePlay methodsFor: 'initialization' stamp: 'hlsf 9/10/2020 15:21:22'!
defaultColor
	^ `Color black`! !

!GamePlay methodsFor: 'initialization' stamp: 'hlsf 9/21/2020 13:52:41'!
initialize
	super initialize.
	extent _ 500 @ 500.
	self setProperty: #'handlesKeyboard' toValue: true.
	self setProperty: #'handlesMouseOver:' toValue: true.
	self startSteppingStepTime: self stepTime.
	self initializeActors.! !

!GamePlay methodsFor: 'initialization' stamp: 'hlsf 9/26/2020 16:28:07'!
initializeActors
	centralStar _ CentralStar new.
	torpedoes _ OrderedCollection new.
	ships _ Array 
		with: SpaceShip new
		with: SpaceShip new.
	ships first 
		color: Color white; 
		position: 200 @ 200.
	ships second
		color: Color red;
		position: -200 @ -200.
		
	self addAllMorphs: ships.
	self addMorph: centralStar.! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/26/2020 16:23:03'!
addTorpedo: aTorpedo
	torpedoes add: aTorpedo.
	self addMorph: aTorpedo.
	aTorpedo startStepping! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/27/2020 10:46:17'!
destroyTorpedo: aTorpedo
	torpedoes remove: aTorpedo.
	aTorpedo dismissMorph. 
	! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/21/2020 20:41:20'!
keyStroke: event
	| key |
	key _ event keyCharacter.
	key = Character arrowUp ifTrue: [ships first push].
	key = Character arrowRight ifTrue: [ships first right].
	key = Character arrowLeft ifTrue: [ships first left].
	key = Character arrowDown ifTrue: [ships first fireTorpedo]! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/26/2020 14:03:37'!
mouseEnter: evt
	evt hand newKeyboardFocus: self.	
	self startStepping.
	submorphs do: [:each | each startStepping]! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/26/2020 14:03:27'!
mouseLeave: evt
	evt hand releaseKeyboardFocus: self.
	self stopStepping.
	submorphs do: [:each | each stopStepping].
! !

!GamePlay methodsFor: 'events' stamp: 'hlsf 9/27/2020 12:32:18'!
teleport: aShip
"Teleport a ship at a random location"
	| area |
	area _ extent - 40.
	aShip 
		velocity: 0@0;
		position: (aShip transformation 
			inverseTransform: (area x asInteger atRandom + 20) @ (area y asInteger atRandom + 20))! !

!GamePlay methodsFor: 'focus handling' stamp: 'hlsf 9/10/2020 16:04:35'!
keyboardFocusChange: gotFocus
	gotFocus 
		ifTrue: [color _ self defaultColor ]
		ifFalse: [color _ self defaultColor alpha: 0.5].
	self redrawNeeded.! !

!GamePlay methodsFor: 'stepping' stamp: 'hlsf 9/27/2020 14:47:28'!
step
	"self redrawNeeded "
	| shipsBound starBound |
	"Precompute the actors bounds for efficiency" 
	shipsBound _ ships collect: [:ship | Array with: ship shipBounds with: ship].
	starBound _ centralStar morphBounds expandBy: -5.
	"Collision between torpedos and the central star then the ships" 
	torpedoes do: [:torpedo | | torpedoBound |
		torpedoBound _ torpedo morphBounds expandBy: -3.
		(torpedoBound intersects: starBound) 
			ifTrue: [
				torpedo flashWith: Color red.
				self destroyTorpedo: torpedo]
			ifFalse: [
				shipsBound do: [:shipData |
					(torpedoBound intersects: shipData first) ifTrue: [
						shipData second flashWith: shipData second color.
						self destroyTorpedo: torpedo			]
					]
			]
		].
	"Collision between central star and ships"
	shipsBound do: [:shipData |
		(shipData first intersects: starBound) ifTrue: [
			shipData second flashWith: shipData second color.
			self teleport: shipData second]].
	"Collision between ships"
		(shipsBound first first intersects: shipsBound second first) ifTrue: [
			ships do: [:ship | 
				ship flashWith: ship color.
				self teleport: ship]			]! !

!GamePlay methodsFor: 'stepping' stamp: 'hlsf 9/27/2020 11:17:13'!
stepTime
	^ 100! !

!GamePlay methodsFor: 'stepping' stamp: 'hlsf 9/27/2020 11:16:20'!
wantsSteps
	^ true! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 9/27/2020 14:47:09'!
initialize
	super initialize.
	heading _ Float halfPi.
	velocity _ 0 @ 0.
	position _ 100 @ 100.
	acceleration _ 0.
	shape _ Array new: 5 withAll: 0@0.
	shipBounds _ 0@0 corner: 0@0! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 15:04:45'!
direction
"I am an unit vector representing the noze direction of the ship"
	 ^ heading cos @ heading sin
	! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/17/2020 15:35:21'!
mass
	^ 1! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 15:05:10'!
normal
"A vector normal to the direction heading of the ship"
	| direction |
	direction _ self direction.
	 ^ direction y negated @ direction x
	! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 20:47:48'!
nose

	^ self direction * 30! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/17/2020 15:14:55'!
position: aPoint
	position _ aPoint ! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/27/2020 14:46:52'!
shipBounds
	^ shipBounds! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 15:07:02'!
transformation
"The transofmration matrix to compute the ship coordinates in the gameplay view"
	^ AffineTransformation withPointScale: 1 @ -1 position: owner morphExtent / 2.0.
! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/17/2020 15:15:21'!
velocity: aPoint
	velocity _ aPoint ! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 9/26/2020 13:36:18'!
drawOn: canvas
	canvas line: shape first to: shape second width: 2 color: color.
	canvas line: shape third to: shape second width: 2 color: color.
	canvas line: shape first to: shape third width: 2 color: color.
	"Draw gas exhaust"
	acceleration ifNotZero: [
		canvas line: shape fourth to: shape fifth width: 1 color: Color gray]

	! !

!SpaceShip methodsFor: 'computing' stamp: 'hlsf 9/17/2020 15:35:06'!
gravity
"Compute the gravity acceleration vector"
	^ [-10 * self mass * owner starMass / (position r raisedTo: 3) * position]
		on: Error do: [0 @ 0]! !

!SpaceShip methodsFor: 'computing' stamp: 'hlsf 9/26/2020 15:45:17'!
updateOuterSpace
	"Are we out of screen?
	If so we move the ship to the other corner and slow it down by a factor of 2"
	(self isInOuterSpace and: [self isGoingOuterSpace])
		ifTrue: [velocity _ velocity / 2.
			position _ position negated]! !

!SpaceShip methodsFor: 'computing' stamp: 'hlsf 9/26/2020 16:30:04'!
updatePosition
"Update the ship position and velocity "
	| ai ag newVelocity t |
	"acceleration vectors"
	t _ self stepTimeInSecond.
	ai _ acceleration * self direction.
	ag _ self gravity.
	newVelocity _ (ai + ag) * t + velocity.
	position _ (0.5 * (ai + ag) * t squared) + (velocity * t) + position.
	velocity _ newVelocity .
	self updateOuterSpace ! !

!SpaceShip methodsFor: 'testing' stamp: 'hlsf 9/16/2020 15:07:18'!
isGoingOuterSpace
"is the ship going crazy in the outer space?"
	^ (position dotProduct: velocity) > 0 ! !

!SpaceShip methodsFor: 'testing' stamp: 'hlsf 9/16/2020 15:07:34'!
isInOuterSpace
"Is the ship located in the outer space? (outside of the game playarea)"
	^ (((0@0 extent: owner morphExtent) expandBy: 20) containsPoint: (self transformation transform: position)) not
		! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/27/2020 10:53:53'!
fireTorpedo
"Fire a torpedo in the direction of the ship heading with a combined velocity"
	| torpedo | 
	torpedo _ Torpedo new.
	torpedo 
		position: position + self nose;
		direction: self direction;
		velocity: self direction * 100 + velocity.
	owner addTorpedo: torpedo.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:07:51'!
left
"Rotate the ship to its left"
	heading _ heading + 0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/26/2020 15:56:07'!
push
"Init an accelaration boost"
	acceleration _ 50! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:01'!
right
"Rotate the ship to its right"
	heading _ heading - 0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:18'!
unpush
"Stop the accelaration boost"
	acceleration _ 0! !

!SpaceShip methodsFor: 'stepping' stamp: 'hlsf 9/27/2020 14:48:13'!
step
	| m u n |
	"Apply the mechanic laws"
	self updatePosition.
	self unpush.
	"Recompute the shape"
	m _ self transformation.
	u _ self nose.
	n _ self normal * 10.
	shape at: 1 put: (m transform: position + n).
	shape at: 2 put: (m transform: position - n).
	shape at: 3 put: (m transform: position + u).
	"tail of the engine gas exhaust, if any"
	shape at: 4 put: (m transform: position).	
	shape at: 5 put: (m transform: position - u).
	shipBounds _ Rectangle encompassing: (shape first: 3).
	self updateBounds: ((Rectangle encompassing: shape) expandBy: 6)! !

!SpaceShip methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 13:31:14'!
stepTime
	^ 20! !

!SpaceShip methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 13:31:33'!
stepTimeInSecond
	^ self stepTime / 1000! !

!SpaceShip methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 15:52:51'!
updateBounds: rect
	extent _ rect extent.
	self morphPosition: rect origin.
	shape _ shape collect: [:aPoint | aPoint - rect origin]
	! !

!SpaceShip methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 13:43:24'!
wantsSteps
	^ true! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/26/2020 14:27:00'!
direction: aVector
	heading _ aVector y arcTan: aVector x! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/26/2020 16:58:11'!
mass
	^ 1! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 20:53:04'!
position: aPoint
	position _ aPoint ! !

!Torpedo methodsFor: 'computing' stamp: 'hlsf 9/26/2020 15:46:00'!
updateOuterSpace
"just let the torpedo goes outerspace"! !

!Torpedo methodsFor: 'computing' stamp: 'hlsf 9/27/2020 10:56:05'!
updatePosition
"Update the torpedo position"
	super updatePosition.
	"update the heading, so we have a torpedo following the heading"
	self direction: velocity.
	acceleration > 0 ifTrue: [acceleration _ acceleration - 200].! !

!Torpedo methodsFor: 'drawing' stamp: 'hlsf 9/26/2020 15:54:45'!
drawOn: canvas
	canvas line: shape first to: shape second width: 2 color: color.
	canvas line: shape third to: shape second width: 2 color: color.
	canvas line: shape first to: shape third width: 2 color: color.
! !

!Torpedo methodsFor: 'initialization' stamp: 'hlsf 9/27/2020 10:55:57'!
initialize
	super initialize.
	color _ Color red.
	lifeSpan _ 500.
	acceleration _ 1000.
	shape _ Array new: 3 withAll: 0@0! !

!Torpedo methodsFor: 'stepping' stamp: 'hlsf 9/27/2020 10:49:49'!
step
	| m n |
	self updatePosition.
	m _ self transformation.	
	n _ self normal * 2.
	shape at: 1 put: (m transform: position + n).
	shape at: 2 put: (m transform: position - n).
	shape at: 3 put: (m transform: position + (self direction * 8)).
	self updateBounds: ((Rectangle encompassing: (shape first: 3)) expandBy: 3).	
	lifeSpan _ lifeSpan - 1.
	lifeSpan isZero ifTrue: [owner destroyTorpedo: self]! !

!Torpedo methodsFor: 'stepping' stamp: 'hlsf 9/26/2020 16:22:32'!
wantsSteps
	^ false! !
