extends TitansResource
class_name AbilityResource

const TARGET_TYPE = {
	"ALLY_FLOOR" : "ALLY_FLOOR" , "ALLY_UNIT" : "ALLY_UNIT", "ENEMY_UNT" : "ENEMY_UNIT", "ENEMY_FLOOR" : "ENEMY_FLOOR", "SELF" : "SELF"
}
const ABILITY_TYPE = {
	"ACTION" : "ACTION" , "STANCE" : "STANCE" , "INSTANT" : "INSTANT"
}

var key : String
var fullName : String
var shortName : String
var abilityType : String
var validTargets : Array = []
var validFrom : Array = []
var iconPath : String

var powerHiBase = 0
var powerLoBase = 0
var toHitBase = 80
var alwaysHits = false

var effects = {
	"ALLY_UNIT" : null, 
	"ALLY_FLOOR" : null,
	"ENEMY_UNIT" : null,
	"ENEMY_FLOOR" : null,
	"SELF" : null
}

func get_class(): 
	return "AbilityResource"

func is_class( name : String ): 
	return name == "AbilityResource"

func _init( newKey : String , jsonFileName : String ):
	key = newKey
	fillableProps = [
		"fullName" , 
		"shortName" , 
		"validTargets" , 
		"validFrom" , 
		"iconPath",
		"powerHiBase",
		"powerLoBase",
		"toHitBase",
		"alwaysHits"
		]
	
	var abilityFile = File.new()
	abilityFile.open( jsonFileName , File.READ)
	var abilityTable = parse_json( abilityFile.get_as_text() )
	abilityFile.close()

	flushAndFillProperties(abilityTable[key] , self)

func calculateSpecialProperties( props: Dictionary , object ):
	var tempEffects = effects.duplicate()
	
	for targetKey in props.targeting:
		tempEffects[targetKey] = props.targeting[targetKey]

	print(tempEffects)


func getTargetArea():
	# Utilzing Valid from & valid to as filters
	# Return a 9 x 9 targeting grid based on targeting type
	pass

func rollAbility():
	# Loop through each effect and apply a roll
	pass

func executeAbility():
	pass
