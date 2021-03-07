extends MeshInstance

const ROTATION_RATE = .05

var myPlanet : PlanetResource

func _physics_process(delta):
	rotation.y = rotation.y + ROTATION_RATE * delta

func setupScene( newPlanet : PlanetResource ):
	myPlanet = newPlanet
