extends TitansResource
class_name SystemResource

export(int) var starsToGenerate = 1
export(int) var mySeed = 10000000
export(String) var systemName = null

var stars : Array = []
var anoms : Array = []

func _init( aSeed: int = 0):
	if( mySeed != 0):
		seed(aSeed)
	else:
		seed(mySeed)
	
	mySeed = genRandomSeed()
	generateStars()

func generateStars():
	for _x in range(0, starsToGenerate):
		var star : StarResource = StarResource.new(mySeed)
		stars.append(star)
	
	print(stars)

func generateAnoms():
	pass
