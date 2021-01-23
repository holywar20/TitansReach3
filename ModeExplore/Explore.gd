extends Node2D

export(int) var mySeed = 1000000

onready var systemGenerator : Node = $SystemGenerator
onready var stars : Node2D = $Stars
onready var planets : Node2D = $Planets
onready var anoms : Node2D = $Anoms

func _ready() -> void:
	setupScene( mySeed )

func setupScene( aSeed : int ) -> void:
	mySeed = aSeed
	
	systemGenerator.generateEntireSystem( mySeed )
