extends Particles

var rotationRate : float = 0.01

func _physics_process(delta):
	rotation.y = rotation.y + ( delta * rotationRate )
