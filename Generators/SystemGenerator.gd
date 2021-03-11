extends Node

export(int) var mySeed = 10000000
export(int) var generatedStars = 1
export(int) var generatedPlanets = 9

var starScene = preload("res://ModeExplore/Celestials/Star/Star.tscn")
var planetScene = preload( "res://ModeExplore/Celestials/Planet/Planet.tscn")

var system : SystemResource

func generateEntireSystem( aSeed : int = 0 ) -> SystemResource:
	if( mySeed != 0):
		mySeed = aSeed
	
	system = SystemResource.new( mySeed )

	return system

func buildStarMesh( star: StarResource ) -> Spatial:
	var starInstance = starScene.instance()
	starInstance.setupScene( star )
	
	return starInstance

func buildPlanetMesh( planet : PlanetResource ) -> Spatial:
	var planetInstance = planetScene.instance()
	planetInstance.setupScene( planet )

	return planetInstance
