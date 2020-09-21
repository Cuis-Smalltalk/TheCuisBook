'From Cuis 5.0 [latest update: #4249] on 21 September 2020 at 9:15:59 pm'!
'Description '!
!provides: 'Spacewar!!' 1 47!
SystemOrganization addCategory: #'Spacewar!!'!


!classDefinition: #CentralStar category: #'Spacewar!!'!
RectangleLikeMorph subclass: #CentralStar
	instanceVariableNames: 'mass'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'CentralStar class' category: #'Spacewar!!'!
CentralStar class
	instanceVariableNames: ''!

!classDefinition: #SpaceShip category: #'Spacewar!!'!
RectangleLikeMorph subclass: #SpaceShip
	instanceVariableNames: 'name position heading velocity fuel torpedoes acceleration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceShip class' category: #'Spacewar!!'!
SpaceShip class
	instanceVariableNames: ''!

!classDefinition: #SpaceWar category: #'Spacewar!!'!
RectangleLikeMorph subclass: #SpaceWar
	instanceVariableNames: 'ships torpedoes centralStar timeLapse'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'SpaceWar class' category: #'Spacewar!!'!
SpaceWar class
	instanceVariableNames: 'timeLapse'!

!classDefinition: #Torpedo category: #'Spacewar!!'!
RectangleLikeMorph subclass: #Torpedo
	instanceVariableNames: 'position velocity direction lifeSpan'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Spacewar!!'!
!classDefinition: 'Torpedo class' category: #'Spacewar!!'!
Torpedo class
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

!CentralStar methodsFor: 'accessing' stamp: 'hlsf 9/10/2020 14:00:10'!
mass: anInteger
	mass _ anInteger ! !

!CentralStar methodsFor: 'drawing' stamp: 'hlsf 9/16/2020 16:05:41'!
drawOn: canvas
	canvas ellipseCenterX: owner morphExtent x // 2 
		y:  owner morphExtent y // 2 
		rx: 10 + (2 atRandom - 1)
		ry: 10 + (2 atRandom - 1)
		borderWidth: 2 
		borderColor: Color orange 
		fillColor: Color yellow ! !

!CentralStar methodsFor: 'initialization' stamp: 'hlsf 9/16/2020 16:06:06'!
initialize
	super initialize.
	mass _ 8000.! !

!SpaceShip methodsFor: 'initialization' stamp: 'hlsf 9/17/2020 15:35:28'!
initialize
	super initialize.
	heading _ Float halfPi.
	velocity _ 0 @ 0.
	position _ 100 @ 100.
	acceleration _ 0.! !

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

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/17/2020 15:14:55'!
position: aPoint
	position _ aPoint ! !

!SpaceShip methodsFor: 'accessing' stamp: 'hlsf 9/17/2020 15:15:21'!
velocity: aPoint
	velocity _ aPoint ! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 9/21/2020 20:47:48'!
drawOn: canvas
	| m u n a b c |
	m _ self transformation.
	
	u _ self nose.
	n _ self normal * 10.
	a _ m transform: position + n.
	b _ m transform: position - n.
	c _ m transform: position + u.
	canvas line: a to: b width: 2 color: color.
	canvas line: c to: b width: 2 color: color.
	canvas line: a to: c width: 2 color: color.
	
	"Draw gas exhaust"
	acceleration ifNotZero: [
		canvas line: (m transform: position) to: (m transform: position - u) width: 1 color: Color gray]

	! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 9/21/2020 20:47:48'!
nose

	^ self direction * 30! !

!SpaceShip methodsFor: 'drawing' stamp: 'hlsf 9/16/2020 15:07:02'!
transformation
"The transofmration matrix to compute the ship coordinates in the gameplay view"
	^ AffineTransformation withPointScale: 1 @ -1 position: owner morphExtent / 2.0.
! !

!SpaceShip methodsFor: 'computing' stamp: 'hlsf 9/17/2020 15:35:06'!
gravity
"Compute the gravity acceleration vector"
	^ [-10 * self mass * owner starMass / (position r raisedTo: 3) * position]
		on: Error do: [0 @ 0]! !

!SpaceShip methodsFor: 'computing' stamp: 'hlsf 9/21/2020 21:00:38'!
update
"Update the ship position and velocity "
	| ai ag newVelocity t |
	"acceleration vectors"
	t _ owner stepTimeInSecond.
	ai _ acceleration * self direction.
	ag _ self gravity.
	newVelocity _ (ai + ag) * t + velocity.
	position _ (0.5 * (ai + ag) * t squared) + (velocity * t) + position.
	velocity _ newVelocity .
	
	"Are we out of screen?
	If so we move the ship to the other corner and slow it down by a factor of 2"
	(self isInOuterSpace and: [self isGoingOuterSpace])
		ifTrue: [velocity _ velocity / 2.
			position _ position negated]! !

!SpaceShip methodsFor: 'testing' stamp: 'hlsf 9/16/2020 15:07:18'!
isGoingOuterSpace
"is the ship going crazy in the outer space?"
	^ (position dotProduct: velocity) > 0 ! !

!SpaceShip methodsFor: 'testing' stamp: 'hlsf 9/16/2020 15:07:34'!
isInOuterSpace
"Is the ship located in the outer space? (outside of the game playarea)"
	^ (((0@0 extent: owner morphExtent) expandBy: 20) containsPoint: (self transformation transform: position)) not
		! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/21/2020 21:14:16'!
fireTorpedo
"Fire a torpedo in the direction of the ship heading with a combined velocity"
	| torpedo | 
	torpedo _ Torpedo new.
	torpedo 
		position: position + self nose;
		direction: self direction;
		velocity: self direction * 50 + velocity.
	owner addTorpedo: torpedo.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:07:51'!
left
"Rotate the ship to its left"
	heading _ heading + 0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:10'!
push
"Init an accelaration boost"
	acceleration _ 10! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:01'!
right
"Rotate the ship to its right"
	heading _ heading - 0.1.! !

!SpaceShip methodsFor: 'control' stamp: 'hlsf 9/16/2020 15:08:18'!
unpush
"Stop the accelaration boost"
	acceleration _ 0! !

!SpaceWar methodsFor: 'accessing' stamp: 'hlsf 9/16/2020 16:41:40'!
starMass
	^ centralStar mass! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 9/10/2020 15:21:22'!
defaultColor
	^ `Color black`! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 9/21/2020 13:52:41'!
initialize
	super initialize.
	extent _ 500 @ 500.
	self setProperty: #'handlesKeyboard' toValue: true.
	self setProperty: #'handlesMouseOver:' toValue: true.
	self startSteppingStepTime: self stepTime.
	self initializeActors.! !

!SpaceWar methodsFor: 'initialization' stamp: 'hlsf 9/21/2020 21:12:07'!
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
	self addMorph: centralStar! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/21/2020 20:56:33'!
addTorpedo: aTorpedo
	torpedoes add: aTorpedo.
	self addMorph: aTorpedo ! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/21/2020 21:10:33'!
destroyTorpedo: aTorpedo
	aTorpedo delete.
	torpedoes remove: aTorpedo ! !

!SpaceWar methodsFor: 'events' stamp: 'hlsf 9/21/2020 20:41:20'!
keyStroke: event
	| key |
	key _ event keyCharacter.
	key = Character arrowUp ifTrue: [ships first push].
	key = Character arrowRight ifTrue: [ships first right].
	key = Character arrowLeft ifTrue: [ships first left].
	key = Character arrowDown ifTrue: [ships first fireTorpedo]! !

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

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/21/2020 20:57:11'!
step
	ships do: [:each | each update].
	ships do: [:each | each unpush].
	torpedoes do: [:each | each update].
	self redrawNeeded ! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/11/2020 13:19:07'!
stepTime
"millisecond"
	^ 20! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/21/2020 21:00:27'!
stepTimeInSecond
	^ timeLapse ifNil: [timeLapse _ self stepTime / 1000]! !

!SpaceWar methodsFor: 'stepping' stamp: 'hlsf 9/10/2020 18:03:59'!
wantsSteps
	^ true! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 20:53:51'!
direction: aVector
	direction _ aVector ! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 21:04:20'!
normal
"A vector normal to the direction heading of the ship"
	^ direction y negated @ direction x
	! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 20:53:04'!
position: aPoint
	position _ aPoint ! !

!Torpedo methodsFor: 'accessing' stamp: 'hlsf 9/21/2020 20:54:04'!
velocity: aVector
	velocity _ 	aVector ! !

!Torpedo methodsFor: 'computing' stamp: 'hlsf 9/21/2020 21:10:36'!
update
"Update the torpedo position"
	position _ (velocity * owner stepTimeInSecond) + position.
	lifeSpan _ lifeSpan - 1.
	lifeSpan isZero ifTrue: [owner destroyTorpedo: self]! !

!Torpedo methodsFor: 'drawing' stamp: 'hlsf 9/21/2020 21:06:04'!
drawOn: canvas
	| m n a b c |
	m _ self transformation.
	
	n _ self normal * 2.
	a _ m transform: position + n.
	b _ m transform: position - n.
	c _ m transform: position + (direction * 8).
	canvas line: a to: b width: 2 color: color.
	canvas line: c to: b width: 2 color: color.
	canvas line: a to: c width: 2 color: color.
! !

!Torpedo methodsFor: 'drawing' stamp: 'hlsf 9/21/2020 21:01:36'!
transformation
"The transofmration matrix to compute the ship coordinates in the gameplay view"
	^ AffineTransformation withPointScale: 1 @ -1 position: owner morphExtent / 2.0.
! !

!Torpedo methodsFor: 'initialization' stamp: 'hlsf 9/21/2020 21:07:31'!
initialize
	super initialize.
	color _ Color red.
	lifeSpan _ 500.! !
