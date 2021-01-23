extends Control

onready var menu = $Menu

signal DEBUG_START_BATTLE
signal DEBUG_EXPLORE_SYSTEM

func _ready():
	pass # Replace with function body.

func _onMenuButtonToggled( toggle ):
	if( toggle ):
		menu.hide()
	else:
		menu.show()

func _onStartBattlePressed():
	emit_signal("DEBUG_START_BATTLE") 

func _onExploreSystemPressed():
	emit_signal("DEBUG_EXPLORE_SYSTEM")
