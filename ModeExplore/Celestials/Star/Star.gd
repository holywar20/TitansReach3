extends MeshInstance

var rotationRate : float = 0.03

func _physics_process(delta):
	rotation.y = rotation.y + ( delta * rotationRate )


