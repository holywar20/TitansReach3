extends Node

var scenes = {
	'explore' : "res://ModeExplore/Explore.tscn",
	'battle' : null
}

onready var debugMenu = $GameUI/DebugMenu
onready var mainMenu = $GameUI/MainMenu
onready var currentScene = $CurrentScene


var gameSeed = 100000000

func _ready():
	pass

# Main Menu Controls
func _on_MainMenu_GAMEMENU_NEW_GAME():
	mainMenu.visible = false

	var exploreScene = load(scenes.explore)
	var exploreInstance = exploreScene.instance()
	
	exploreInstance.setupScene(gameSeed)

	add_child(exploreInstance)


# Debug control signals
func _on_DebugMenu_DEBUG_EXPLORE_SYSTEM():
	pass # Replace with function body.


func _on_DebugMenu_DEBUG_START_BATTLE():
	pass # Replace with function body.
