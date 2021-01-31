extends Node2D

export(int) var mySeed = 1000000

onready var systemGenerator : Node = $SystemGenerator
onready var crewGenerator : Node = $CrewGenerator

onready var stars : Node2D = $Stars
onready var planets : Node2D = $Planets
onready var anoms : Node2D = $Anoms

onready var viewPortCamera : Camera = $Background/ViewportContainer/Viewport/Camera
onready var closeParticles : CPUParticles2D = $Background/StarfieldClose/CPUParticles2D
onready var midParticles : CPUParticles2D = $Background/StarfieldMid/CPUParticles2D
onready var farParticles : CPUParticles2D = $Background/StarfieldUnder/CPUParticles2D

# Various fudge factors for managing the relationship between 2d & 3d elements
const SCALE_2DTO3D_FACTOR = 1000
const PARTICLE_SPEED_FACTOR = .1
const BASE_PARTICLE_SPEED = 5

var thisSystem : SystemResource = null
var myCrew : Array = [] # An array of Character Resources

func _ready() -> void:
	setupScene( mySeed )

func setupScene( aSeed : int ) -> void:
	mySeed = aSeed
	thisSystem = systemGenerator.generateEntireSystem( mySeed )
	myCrew = crewGenerator.generateManyCrew(30 , 10)

func _on_PlayerShip_PLAYER_MOVING( newPosition : Vector2 , velocity : Vector2 , angularVelocity : float , shipRotation : float):
	_move3dCamera( newPosition )
	_moveParticles( velocity , shipRotation)

# Moves particles to reflect direction of movement
func _moveParticles( velocity : Vector2 , shipRotation:float ):
	var tVector : Vector2 = velocity.abs()
	var potentialSpeed = PARTICLE_SPEED_FACTOR * max(tVector.x , tVector.y)

	closeParticles.set_speed_scale( max( potentialSpeed , BASE_PARTICLE_SPEED ) )
	closeParticles.set_rotation( shipRotation )
	
	midParticles.set_speed_scale( max( potentialSpeed , BASE_PARTICLE_SPEED * .75) )
	midParticles.set_rotation( shipRotation )
	
	farParticles.set_speed_scale( max( potentialSpeed , BASE_PARTICLE_SPEED * .20  ) )
	farParticles.set_rotation( shipRotation )

# Moves the 3D Camera to match the 2D Camera.
func _move3dCamera( position : Vector2 ):
	var viewPortCamPos = viewPortCamera.get_translation()
	
	var x = ( position.x ) / SCALE_2DTO3D_FACTOR
	var y = ( position.y ) / SCALE_2DTO3D_FACTOR
	var translatedVector3 = Vector3(x , viewPortCamPos.y  ,y)
	
	viewPortCamera.set_translation( translatedVector3 )
