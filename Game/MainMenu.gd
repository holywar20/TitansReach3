extends Control

signal GAMEMENU_NEW_GAME

func newGameButtonClick():
	self.visible = false
	emit_signal("GAMEMENU_NEW_GAME")

func exit_tree():
	pass
