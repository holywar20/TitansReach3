extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

# TODO Eventually use this with some kind of save file mechanism. For now, we rely entirely upon Core.db
var CORE_DB_PATH = "res://Generators/Data/Core.db" 
var db

# DATA 
onready var Inventory : Node = $Inventory
onready var AbilityStore : Node = $AbilityStore
onready var Crew : Node = $Crew
onready var StarshipStore : Node = $StarshipStore

func _ready():
	db = SQLite.new()
	db.path = CORE_DB_PATH
	db.verbose_mode = false
	db.open_db()
	
	Inventory.setupData( db )
	AbilityStore.setupData( db )
	Crew.setupData( db )
	StarshipStore.setupData( db )
