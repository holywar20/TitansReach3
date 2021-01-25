extends Node

export(int) var mySeed = 10000000
export(int) var generatedStars = 1
export(int) var generatedPlanets = 9

const meshScenes = {
	"Star" : "res://ModeExplore/Celestials/Star.tscn"
}

var system : SystemResource

func generateEntireSystem( aSeed : int = 0 ) -> SystemResource:
	if( mySeed != 0):
		mySeed = aSeed
	
	system = SystemResource.new( mySeed )

	return system

func buildStarMesh( star: StarResource ) -> MeshInstance:
	var starScene = load( meshScenes.Star )
	var starInstance = starScene.instance()
	starScene.setupScene( star )
	
	return starScene
