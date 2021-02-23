extends AnimatedSprite

func _ready():
	print("I exist!")

func _on_AnimatedSprite_animation_finished():
	queue_free()
