extends TitansResource
class_name SystemResource

export(int) var starsToGenerate = 1
export(int) var mySeed = 10000000
export(String) var systemName = null

var stars : Array = []
var anoms : Array = []

# Overrides
func get_class() -> String: 
	return "SystemResource"

func is_class( name : String ) -> bool: 
	return name == "SystemResource"

func _init( aSeed: int = 0):
	if( mySeed != 0):
		seed(aSeed)
	else:
		seed(mySeed)
	
	mySeed = genRandomSeed()
	generateStars()

func generateStars():
	for _x in range(0, starsToGenerate):
		var star : StarResource = StarResource.new(mySeed , self)
		stars.append(star)

func generateAnoms():
	pass
