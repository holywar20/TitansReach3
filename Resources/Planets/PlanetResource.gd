extends Resource
class_name PlanetResource

enum MINERALS { GOLD, URANIUM }
enum CLASS { TERRAN, LAVA , FROZEN , BARREN , DESERT , GAS } 

export(int) var planetSeed = 1000000

export(String) var title = "Unknown Planet"
export(CLASS) var planetClass = CLASS.TERRAN

export(float) var mass = 1.0
export(int) var temp = 5500

func _ready():
	pass # Replace with function body.

