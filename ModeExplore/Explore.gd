extends Node2D

export(int) var mySeed = 1000000

func _ready() -> void:
	pass

func setupScene( aSeed : int ) -> void:
	mySeed = aSeed



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
