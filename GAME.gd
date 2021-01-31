extends Node

var exploreScene : PackedScene = preload("ModeExplore/Explore.tscn")

onready var debugMenu = $GameUI/DebugMenu
onready var mainMenu = $GameUI/MainMenu
onready var currentScene = $CurrentScene

var gameSeed = 100000000

func _ready():
	pass

# Main Menu Controls
func _on_MainMenu_GAMEMENU_NEW_GAME() -> void:
	mainMenu.visible = false

	var exploreInstance = exploreScene.instance()
	add_child(exploreInstance)

	exploreInstance.setupScene(gameSeed)


# Debug control signals
func _on_DebugMenu_DEBUG_EXPLORE_SYSTEM() -> void:
	pass # Replace with function body.


func _on_DebugMenu_DEBUG_START_BATTLE() -> void:
	pass # Replace with function body.
