extends RigidBody2D

export(bool) var isPlayer = false
export(float) var rotationAcceleration = .1
export(int) var rotationSpeed = 5

export(int) var acceleration = 200
export(int) var velocityMaxForward = 500

const MAX_ZOOM_IN = .5
const MAX_ZOOM_OUT = 6
const ZOOM_STEP = .05
const ROTATION_SPEED_THRESHOLD = 5
const MOVEMENT_SPEED_THRESHOLD = 1

var stopping = false
var vectorDirection = Vector2(0,0)
var speed = 0

signal PLAYER_MOVING # Emitted when ever a player moves in any direction or rotates.

onready var myCamera = $Camera
onready var area2D = $ShipArea # I need this for collision detection of areas for some reason. Rigid2D Bodies can't poll for areas, only for bodies, and i'm using mostly areas.
onready var ship = $Ship
# onready var viewPortCamera = get_node("../ViewPortCanvas/ViewportContainer/Celestials/Camera")

var starship = null

func _ready():
	set_position( Vector2( 0 ,100 ) )

# put collision handling on the objects themselves.
# func _onAreaEntered( area : Area2D ):
	#pass 
	# var objects = area2D.get_overlapping_areas()

#func _onAreaExited( area : Area2D ):
	#pass
	#var objects = area2D.get_overlapping_areas()

	#for x in range( 0, objects.size() ) :
	#	if( objects[x].get_name() == area.get_name() ):
	#		objects.erase( area )
	#		break

#func _unhandled_input( ev : InputEvent ) ->void:
	#pass
	# TODO - add some smoothing to this to make it look nicer.
	#if( ev.is_action_pressed( "GUI_ZOOM_IN" ) ):
	#	var myZoom = myCamera.get_zoom() 
		
	#	if( myZoom.x > MAX_ZOOM_IN ):
	#		myCamera.set_zoom( Vector2(myZoom.x - ZOOM_STEP , myZoom.y - ZOOM_STEP) )
	
	#if( ev.is_action_pressed( "GUI_ZOOM_OUT" ) ):
	#	var myZoom = myCamera.get_zoom() 
		
	#	if( myZoom.x < MAX_ZOOM_OUT ):
	#		myCamera.set_zoom( Vector2(myZoom.x + ZOOM_STEP  , myZoom.y + ZOOM_STEP  ) )

func _physics_process( delta : float ) -> void:
	var angularVelocity = get_angular_velocity()
	var linearVelocity  = get_linear_velocity()
	
	if( !stopping ):
		if( Input.is_action_just_pressed("STOP") ):
			print("Stopping!")
			stopping = true

		var rotationInput : float = Input.get_action_strength("TURN_RIGHT") - Input.get_action_strength("TURN_LEFT")
		if( rotationInput ):
			goRotation( rotationInput , delta )
		
		var accelerationInput : float = Input.get_action_strength("ACCELERATE")
		if( accelerationInput ):
			accelerate(acceleration, delta)
		else:
			decelerate( delta )

		if( abs(linearVelocity.x) <= ROTATION_SPEED_THRESHOLD ):
			linearVelocity.x = 0
		if( abs(linearVelocity.y) <= ROTATION_SPEED_THRESHOLD ):
			linearVelocity.y = 0
		if( abs(angularVelocity) <= MOVEMENT_SPEED_THRESHOLD ):
			angularVelocity = 0
	else:
		if( Input.get_action_strength("TURN_RIGHT") || Input.get_action_strength("TURN_LEFT") || Input.get_action_strength("ACCELERATE") ):
			stopping = false
		else:
			goRotation(0, delta*10)
			decelerate(delta*10)

	if( isPlayer ):
		#print(angularVelocity)
		#if( linearVelocity.x != 0 || linearVelocity.y != 0 || angularVelocity != 0 ):
		emit_signal("PLAYER_MOVING", myCamera.get_global_position() , linearVelocity, angularVelocity, rotation)

func goRotation( direction, delta ):
	var newRotationSpeed = get_angular_velocity() + ( rotationSpeed * delta * direction )

	if ( newRotationSpeed > rotationSpeed ):
		newRotationSpeed = 50
	if( newRotationSpeed < (rotationSpeed * -1 ) ):
		newRotationSpeed = -50

	set_angular_velocity( newRotationSpeed )

func decelerate( delta ):
	speed = max(0 , speed - (5 * delta * acceleration ) )
	
	vectorDirection = Vector2( cos( get_rotation() ), sin( get_rotation() ) )
	set_linear_velocity( vectorDirection * speed )

func accelerate( speedFactorIncrease , delta ):
	if( sleeping ):
		sleeping = false
	
	speed = speed + ( speedFactorIncrease * delta * acceleration )
	
	if( speed >= velocityMaxForward ):
		speed = velocityMaxForward
	
	vectorDirection = Vector2( cos( get_rotation() ), sin( get_rotation() ) )
	set_linear_velocity( vectorDirection * speed )

func updateShipStats():
	pass
	# rotationSpeed = ShipManager.getStatTotal( 'agility' )
	# acceleration  = ShipManager.getStatTotal( 'impulse' )

	# velocityMaxForward = acceleration * 5
	# velocityMaxBackward = acceleration * 5
