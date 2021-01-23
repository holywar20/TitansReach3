extends Node

export(int) var mySeed = 10000000
export(int) var generatedStars = 1

var system : SystemResource

func generateEntireSystem( aSeed : int = 0 ) -> SystemResource:
	if( mySeed != 0):
		mySeed = aSeed
	
	system = SystemResource.new( mySeed )

	return system
