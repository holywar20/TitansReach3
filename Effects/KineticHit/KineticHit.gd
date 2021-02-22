extends AnimatedSprite


func _ready():
	connect("animation_finished" , self , "on_self_animamation_finished")

func on_self_animamation_finished():
	queue_free()
