extends MeshInstance

const ROTATION_RATE = .05

func _physics_process(delta):
	rotation.x = rotation.x + ROTATION_RATE * delta
