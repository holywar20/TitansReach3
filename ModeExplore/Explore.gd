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

# Menu Management 
onready var startFocusButton : Button = $UI/TopPanel/ButtonBar/CrewButton
onready var mainContainer : VBoxContainer = $UI/Dropdown/Main
onready var dropdown : Panel = $UI/Dropdown
onready var title : Label = $UI/Dropdown/Main/TitleRow/Label

const NODE_GROUP_MAIN_MENU = "MAIN_MENU"

enum MENU_BUTTONS {
	CREW, CREW_ASSIGNMENT, STARSHIP, CARGO , STARMAP, SYSTEM, TRADE 
}

const MENUS = {
	MENU_BUTTONS.CREW : { 
		"scene" : "res://ModeExplore/Menus/Crew/Crew.tscn",
		"title" : "Medical"
	},
	MENU_BUTTONS.CREW_ASSIGNMENT : {
		"scene" : "res://ModeExplore/Menus/Assignments/Assignments.tscn",
		"title" : "Postings"
	},
	MENU_BUTTONS.STARSHIP : {
		"scene" : "res://ModeExplore/Menus/Starship/Starship.tscn",
		"title" : "Engineering"
	},
	MENU_BUTTONS.CARGO : {
		"scene" : "res://ModeExplore/Menus/Cargo/Cargo.tscn",
		"title" : "Cargohold"
	},
	MENU_BUTTONS.STARMAP : {
		"scene" : "res://ModeExplore/Menus/Starmap/Starmap.tscn",
		"title" : "Starmap"
	},
	MENU_BUTTONS.SYSTEM : {
		"scene" : "res://ModeExplore/Menus/System/System.tscn",
		"title" : "Sensors"
	},
	MENU_BUTTONS.TRADE : {
		"scene" : "res://ModeExplore/Menus/Trade/Trade.tscn",
		"title" : "Markets"
	}	
}

# Various fudge factors for managing the relationship between 2d & 3d elements
const SCALE_2DTO3D_FACTOR = 1000
const PARTICLE_SPEED_FACTOR = .1
const BASE_PARTICLE_SPEED = 5

var thisSystem : SystemResource = null

# Need to hoist this to a neutral place at some point
var myCrew : Array = [] # An array of Character Resources

func _ready() -> void:
	setupScene( mySeed )

func setupScene( aSeed : int ) -> void:
	mySeed = aSeed
	thisSystem = systemGenerator.generateEntireSystem( mySeed )
	myCrew = crewGenerator.generateManyCrew(30 , 10)

	startFocusButton.grab_focus()

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


# Top Menu Buttons
func loadMenuButton( buttonIdx : int ):
	for child in get_tree().get_nodes_in_group( NODE_GROUP_MAIN_MENU ):
		child.queue_free()
	
	var menuScene = load( MENUS[buttonIdx].scene )
	var sceneInstance : Panel = menuScene.instance()
	title.set_text( MENUS[buttonIdx].title )
	
	return sceneInstance
	

func _on_CrewButton_pressed():
	var menuInstance = loadMenuButton( MENU_BUTTONS.CREW )
	
	menuInstance.setupScene( myCrew )
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_CrewAssignment_pressed():
	var menuInstance =  loadMenuButton( MENU_BUTTONS.CREW_ASSIGNMENT)
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_Starship_pressed():	
	var menuInstance = loadMenuButton( MENU_BUTTONS.STARSHIP)
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_Cargo_pressed():	
	var menuInstance = loadMenuButton( MENU_BUTTONS.CARGO )
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_Starmap_pressed():	
	var menuInstance = loadMenuButton( MENU_BUTTONS.STARMAP )
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_System_pressed():
	var menuInstance = loadMenuButton( MENU_BUTTONS.SYSTEM )
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_Trade_pressed():
	var menuInstance = loadMenuButton( MENU_BUTTONS.TRADE )
	
	mainContainer.add_child( menuInstance )
	dropdown.show()

func _on_closeButton_pressed():
	dropdown.hide()
	
	for child in get_tree().get_nodes_in_group( NODE_GROUP_MAIN_MENU ):
		child.queue_free()
