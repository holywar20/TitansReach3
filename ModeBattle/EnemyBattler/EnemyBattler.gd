extends Node2D

var character : CharacterResource

onready var nameLabel : Label = $Name

func _ready():
	pass

func setupScene( newCharacter : CharacterResource ):
	character = newCharacter
	nameLabel.set_text( character.getNickName() )
