extends MeshInstance

const ROTATION_RATE = .05

func _physics_process(delta):
	rotation.y = rotation.y + ROTATION_RATE * delta
