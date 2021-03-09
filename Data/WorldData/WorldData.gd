extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

# TODO Eventually use this with some kind of save file mechanism. For now, we rely entirely upon Core.db
var CORE_DB_PATH = "res://Generators/Data/Core.db" 
var db

# DATA 
onready var Inventory : Node = $Inventory
onready var Ability : Node = $Ability
onready var Crew : Node = $Crew

func _ready():
	db = SQLite.new()
	db.path = CORE_DB_PATH
	db.verbose_mode = true
	
	Inventory.setupData( db )
	Ability.setupData( db )
	Crew.setupData( db )

func generateCharacters():
	pass
