extends Node2D

export(int) var mySeed = 1000000

# Generators and Data
onready var systemGenerator : Node = $SystemGenerator
onready var crewGenerator : Node = $CrewGenerator


onready var inventory : Node = $Inventory 

# TODO put into some kind of wallet resource. Will need this for trade & markets to work
onready var ink = 200000


# Bases
onready var anoms : Node2D = $Anoms
onready var starBase : Spatial = $Background/ViewportContainer/Viewport/Stars
onready var planetBase : Spatial = $Background/ViewportContainer/Viewport/Stars

# Particiles and Camera
onready var viewPortCamera : Camera = $Background/ViewportContainer/Viewport/Camera
onready var closeParticles : CPUParticles2D = $Background/StarfieldClose/CPUParticles2D
onready var midParticles : CPUParticles2D = $Background/StarfieldMid/CPUParticles2D
onready var farParticles : CPUParticles2D = $Background/StarfieldUnder/CPUParticles2D

# Menu Management 
onready var startFocusButton : Button = $UI/TopPanel/ButtonBar/CrewButton
onready var mainContainer : VBoxContainer = $UI/Dropdown/Main
onready var dropdown : Panel = $UI/Dropdown
onready var title : Label = $UI/Dropdown/Main/TitleRow/Label

# Other UI
onready var minimap : PanelContainer = $UI/Minimap

const NODE_GROUP_MAIN_MENU = "MAIN_MENU"

enum MB {
	CREW_ASSIGNMENT, CREW_MANAGEMENT, ENGINEERING, CARGOHOLD , STARMAP, SYSTEM, MARKETS 
}

var buttonQue = [MB.CREW_ASSIGNMENT, MB.CREW_MANAGEMENT , MB.ENGINEERING , MB.CARGOHOLD, MB.STARMAP , MB.SYSTEM , MB.MARKETS]

onready var buttons = {
	MB.CREW_ASSIGNMENT : $UI/TopPanel/ButtonBar/CrewAssignment,
	MB.CREW_MANAGEMENT : $UI/TopPanel/ButtonBar/CrewManagement,
	MB.ENGINEERING : $UI/TopPanel/ButtonBar/Engineering,
	MB.CARGOHOLD : $UI/TopPanel/ButtonBar/Cargohold,
	MB.STARMAP : $UI/TopPanel/ButtonBar/Starmap,
	MB.SYSTEM :  $UI/TopPanel/ButtonBar/System,
	MB.MARKETS : $UI/TopPanel/ButtonBar/Markets
}

const MENUS = {
	MB.CREW_ASSIGNMENT : { 
		"scene" : "res://ModeExplore/Menus/CrewAssignments/CrewAssignments.tscn",
		"title" : "Crew Assignment"
	},
	MB.CREW_MANAGEMENT : {
		"scene" : "res://ModeExplore/Menus/CrewManagement/CrewManagement.tscn",
		"title" : "Crew Management"
	},
	MB.ENGINEERING : {
		"scene" : "res://ModeExplore/Menus/Engineering/Engineering.tscn",
		"title" : "Engineering"
	},
	MB.CARGOHOLD : {
		"scene" : "res://ModeExplore/Menus/Cargohold/Cargohold.tscn",
		"title" : "Cargohold"
	},
	MB.STARMAP : {
		"scene" : "res://ModeExplore/Menus/Starmap/Starmap.tscn",
		"title" : "Starmap"
	},
	MB.SYSTEM : {
		"scene" : "res://ModeExplore/Menus/System/System.tscn",
		"title" : "Sensors"
	},
	MB.MARKETS : {
		"scene" : "res://ModeExplore/Menus/Markets/Markets.tscn",
		"title" : "Markets"
	}	
}

var currentButton = null

# Various fudge factors for managing the relationship between 2d & 3d elements
const SCALE_2DTO3D_FACTOR = 1000
const PARTICLE_SPEED_FACTOR = .1
const BASE_PARTICLE_SPEED = 5

var thisSystem : SystemResource = null

# Need to hoist this to a neutral place at some point
var myCrew : Array = [] # An array of Character Resources

func _ready() -> void:
	setupScene( mySeed )

func _input(event):
	if( event.is_action_pressed("CUSTUI_LEFT_MENU") ):
		if( currentButton == null ):
			currentButton = buttonQue[0]
			print( currentButton )
			buttons[currentButton].set_pressed(true)
		else:
			print(currentButton)
			buttons[currentButton].set_pressed(false)
			currentButton = posmod( currentButton - 1 , buttonQue.size() )
			buttons[currentButton].set_pressed(true)
			
	elif( event.is_action_pressed("CUSTUI_RIGHT_MENU") ):
		if( currentButton == null ):
			currentButton = buttonQue[buttonQue.size() - 1]
			buttons[currentButton].set_pressed(true)
		else:
			buttons[currentButton].set_pressed(false)
			currentButton = posmod( currentButton + 1 , buttonQue.size() )
			buttons[currentButton].set_pressed(true)
			
			
	if( event.is_action_pressed("ui_cancel") ):
		if(currentButton):
			dropdown.hide()
			
			buttons[currentButton].set_pressed(false)
			currentButton = null
	
			for child in get_tree().get_nodes_in_group( NODE_GROUP_MAIN_MENU ):
				child.queue_free()

func setupScene( aSeed : int ) -> void:
	mySeed = aSeed
	thisSystem = systemGenerator.generateEntireSystem( mySeed )

	for star in thisSystem.stars:
		var newStar : Spatial = systemGenerator.buildStarMesh( star )
		# TODO : if we impliment multiple stars, will need to off set their locations
		#starBase.add_child(newStar)

		for planetData in star.planets:
			if( planetData ):
				var newPlanet : Spatial = systemGenerator.buildPlanetMesh( planetData )
				var planetPosition = Vector3( planetData.position2d.x , 0 , planetData.position2d.y )
				newPlanet.set_translation( planetPosition )
				planetBase.add_child( newPlanet )

	minimap.setupScene( thisSystem )
			

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

# Top Menu Buttons
func loadMenu( buttonIdx : int ):
	for child in get_tree().get_nodes_in_group( NODE_GROUP_MAIN_MENU ):
		child.queue_free()
	
	var menuScene = load( MENUS[buttonIdx].scene )
	var sceneInstance : Panel = menuScene.instance()
	title.set_text( MENUS[buttonIdx].title )
	dropdown.show()
	mainContainer.add_child( sceneInstance )
	
	return sceneInstance

func _on_CrewAssignment_toggled(button_pressed):	
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.CREW_ASSIGNMENT )
		menuInstance.setupScene( myCrew )

func _on_CrewManagement_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.CREW_MANAGEMENT )
		menuInstance.setupScene( myCrew )

func _on_Engineering_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.ENGINEERING )

func _on_Cargohold_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.CARGOHOLD )
		menuInstance.setupScene()

func _on_Starmap_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.STARMAP )

func _on_System_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.SYSTEM )

func _on_Markets_toggled(button_pressed):
	if( button_pressed == true ):
		var menuInstance = loadMenu( MB.MARKETS )
