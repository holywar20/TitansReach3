extends MeshInstance

var rotationRate : float = 0.1

func _physics_process(delta):
	rotation.y = rotation.y + ( delta * rotationRate )

func setupScene( starRef : StarResource ):
	pass
