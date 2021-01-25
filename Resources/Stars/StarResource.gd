extends TitansResource
class_name StarResource

enum STAR_CLASS {
	T , M , K , G , F , A, B, O , NEUTRON, BLACKHOLE, RED_GIANT, WOLF_RAYET
}

const PLANET_CHANCE = 100

export(int) var mySeed = 10000000


# Properties which are generally populated from data
export(STAR_CLASS) var starClass = STAR_CLASS.T
var starClassName : String = "Brown Dwarf" 
var boilLine : int = 0
var freezeLine : int = 1
var codex : String = "Brown Dwarf"

var systemScale : float = 0.25
var starScale :float = 0.25
var texturePath : String = "res://AssettsImage/Stars/celestial_blank.png"
var textureIconPath : String = "res://AssettsImage/Stars/celestial_blank_icon.png"
var textureSmallPath : String = "res://AssettsImage/Stars/celestial_blank_small.png"

var isExotic : bool = false 
var isHabitable : bool = false
var anomChance : float = 1

# hi, low, dif props with randomized values
var temp : int = 3000
var mass : float = 0.01

# self or specially determined parameters
var position : Vector2 = Vector2.ZERO
var starName : String = ""

# Data
const NAME_FILE_PATH : String = "res://Generators/Data/NameList.json"
const STAR_FILE_PATH : String = "res://Generators/Data/StarList.json"

# Relationships
var parentSystem # This should be a systemResource

var planets : Array = [false, false, false, false, false, false, false, false, false , false]
var anoms : Array = []

# Overrides
func get_class() -> String: 
	return "StarResource"

func is_class( name : String ) -> bool: 
	return name == "StarResource"

func _init( aSeed: int , systemResource = null )->void:
	if( aSeed != 0 ):
		seed(aSeed)
	else:
		seed(mySeed)

	mySeed = genRandomSeed()

	fillableProps = [
		'starClassName' , 
		'boilLine' , 
		'freezeLine' , 
		'codex' , 
		'isExotic' , 
		'isHabitable' , 
		'anomChance' , 
		'texturePath' , 
		'textureIconPath' , 
		'textureSmallPath', 
		'starScale' ,
		'systemScale'
	]
	hiLoDiffProps = ['temp' , 'mass']

	parentSystem = systemResource

	_generateName()
	_generateProps()
	_generatePlanets()
	_generateAnoms()

# Star Resource API
# Return number of planets between the chosen orbit and the closest star.
func getCurrentPlanetCount( orbitNum ):
	var planetCount = 0
	for x in range(0, orbitNum):
		if planets[x]:
			planetCount += 1

	return planetCount

func addPlanet( orbit : int , planetResource ):
	planets[orbit] = planetResource

# Internal Methods
func _generateAnoms():
	pass

func _generatePlanets():
	for orbit in range( 1 , planets.size() ):
		var planetChance = min( randi() % 100 , PLANET_CHANCE )
		if( planetChance < PLANET_CHANCE ):
			planets[orbit] = PlanetResource.new( mySeed, self , orbit )
		else:
			planets[orbit] = null

func _generateName() -> void:
	var nameFile = File.new()
	nameFile.open(NAME_FILE_PATH, File.READ)
	var nameTable = parse_json( nameFile.get_as_text() )
	
	var fName = nameTable['starSystemFirstNames'][randi() % nameTable['starSystemFirstNames'].size() + 1.0]
	var lName = nameTable['starSystemLastNames'][randi() % nameTable['starSystemLastNames'].size() + 1.0]
	
	starName = fName + lName

	nameFile.close()

func _generateProps() -> void:
	var starFile = File.new()
	starFile.open( STAR_FILE_PATH , File.READ)
	var starTable = parse_json( starFile.get_as_text() )
	starFile.close()

	# Calculate the total 'rollWeight' of all stars
	var totalWeight : int = 1
	for star in starTable:
		totalWeight += star.rollWeight 

	var random = randi() % totalWeight + 1.0
	var weightCount = 0
	
	# Find out which star we are creating
	for x in range( 0, starTable.size() ):
		weightCount += starTable[x].rollWeight
		if( weightCount >= random ):
			starClass = x
			break

	# Now populate all the properties
	var starData : Dictionary = starTable[starClass]
	flushAndFillProperties( starData, self )



	
	
