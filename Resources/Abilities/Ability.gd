extends TitansResource
class_name AbilityResource

# TODO Need to put this into JSON or a database
# TODO Add Hook for a sound player
var masterEffectData = {
	"DEFEND" : { # Passive abilities will mirror the character and be swapped in as a mod, 1 for 1.
		"type" : "PASSIVE",
		"effectAnimation": "DEFENSIVE",
		"mods" : {
			"damageReduction" : {
				"THERMAL" : 20 ,
				"KINETIC" : 20 ,
				"TOXIC"  : 20 ,
				"EM" : 20
			}
		},
	},
	"MOVE_ANYWHERE" : {
		"type" : "MOVEMENT",
		"effectAnimation" : "NONE",
		"movementSubtype" : "ANY",
		"movementAmount" : 5
	},
	"KINETIC_ATTACK_EFFECT" : {
		"type" : "DAMAGE",
		"effectAnimation" : "KINETIC_HIT",
		"dmgType" : "KINETIC",
	},
	"HEAL_EFFECT" :{
		"type" : "HEALING",
		"effectAnimation" : "MEDKIT",	
	}
}
const TARGET_AREA = {
	"SINGLE" : "SINGLE" ,"COLUMN" : "COLUMN", "ROW" : "ROW" , "CROSS" : "CROSS", "ALL" :  "ALL"
}
const TARGET_TYPE = {
	"ALLY_FLOOR" : "ALLY_FLOOR" ,
	"ALLY_FLOOR_EMPTY" : "ALLY_FLOOR_EMPTY", 
	"ALLY_UNIT" : "ALLY_UNIT", 
	"ENEMY_UNIT" : "ENEMY_UNIT", 
	"ENEMY_FLOOR" : "ENEMY_FLOOR", 
	"ENEMY_FLOOR_EMPTY" : "ENEMY_FLOOR_EMPTY",
	"SELF" : "SELF"
}
const ABILITY_TYPE = {
	"ACTION" : "ACTION" , "STANCE" : "STANCE" , "INSTANT" : "INSTANT"
}

const TO_HIT_TRAIT = {
	"ALWAYS" : "ALWAYS" , "DEX" : "DEX" , "STR" : "STR" , "PER" : "PER" , "INT" : "INT" , "CHA" : "CHA"
}
const TO_POWER_TRAIT = {
	"NONE" : "NONE" , "DEX" : "DEX" , "STR" : "STR" , "PER" : "PER" , "INT" : "INT" , "CHA" : "CHA"
}

enum PATH {
	DEFAULT
}

const FILES = {
	PATH.DEFAULT : "res://Generators/Data/Abilities/default.json"
}

const TARGET_MATRIX = {
	TARGET_AREA.SINGLE : [[0 , 0 , 0] , [0 , 1 , 0] , [0 ,0 ,0]],
	TARGET_AREA.COLUMN : [[0 , 1 , 0] , [0 , 1 , 0] , [0 ,1 ,0]],
	TARGET_AREA.ROW    : [[0 , 0 , 0] , [1 , 1,  1] , [0 ,0 ,0]],
	TARGET_AREA.CROSS  : [[0 , 1 , 0] , [1 , 1 , 1] , [0 ,1 ,0]],
	TARGET_AREA.ALL    : [[1 , 1 , 1] , [1 , 1 , 1] , [1 ,1 ,1]]
}

var parentCharacter

var key : String
var fullName : String
var shortName : String
var abilityType : String
var validTargets : Array = []
var validFrom : Array = []
var iconPath : String
var description : String
var targetAreaShown : String = TARGET_AREA.SINGLE

var toHitTrait : String = TO_HIT_TRAIT.ALWAYS
var toPowerTrait : String = TO_POWER_TRAIT.NONE
var toHitBase = 80
var powerHiBase = 0
var powerLoBase = 0


var effectGroups : Array = [] # An array of EffectGroup

class EffectGroup:	
	var targetType : String = TARGET_TYPE.SELF
	var targetArea : String = TARGET_AREA.SINGLE
	var effects : Array = []
	
	var selectedTarget : Vector2 = Vector2.ZERO # This is populated dynamically

	func enemyOrAlly( isPlayerUsing : bool ):
		var targetsPlayer : bool

		match targetType:
			TARGET_TYPE.SELF:
				targetsPlayer = true
			TARGET_TYPE.ALLY_FLOOR:
				targetsPlayer = true
			TARGET_TYPE.ALLY_UNIT:
				targetsPlayer = true
			TARGET_TYPE.ALLY_FLOOR_EMPTY:
				targetsPlayer = true
			TARGET_TYPE.ENEMY_FLOOR:
				targetsPlayer = false
			TARGET_TYPE.ENEMY_UNIT:
				targetsPlayer = false
			TARGET_TYPE.ENEMY_FLOOR_EMPTY:
				targetsPlayer = false
		
		# If the ability user isn't a player, flip the logic
		if( !isPlayerUsing ):
			targetsPlayer = !targetsPlayer
		
		return targetsPlayer
	
func get_class(): 
	return "AbilityResource"

func is_class( name : String ): 
	return name == "AbilityResource"

func _init( newKey : String , filePath : int , character ):
	parentCharacter = character
	key = newKey
	fillableProps = [
		"fullName" , 
		"shortName" , 
		"validTargets" , 
		"validFrom" , 
		"iconPath",
		"toHitTrait",
		"toHitBase",
		"toPowerTrait",
		"powerHiBase",
		"powerLoBase",
		"description",
		"targetAreaShown"	
	]
	
	var abilityFile = File.new()
	abilityFile.open( FILES[filePath] , File.READ)
	var abilityTable = parse_json( abilityFile.get_as_text() )
	abilityFile.close()

	flushAndFillProperties(abilityTable[key] , self)
	_makeEffects( abilityTable[key]['effectGroups'] )

	# Do any type casting to fix json, which comes in as strings
	#validTargets = makeArrayIntegers( validTargets )
	#validFrom = makeArrayIntegers( validFrom )

	# Now make stuff into integers
	#toHitBase = 

func _makeEffects( newEffectGroups : Array ):
	for effectGroupData in newEffectGroups:
		var newEffectGroup = EffectGroup.new()
		
		newEffectGroup.targetArea = effectGroupData['targetArea']
		newEffectGroup.targetType = effectGroupData['targetType']

		for effectKey in effectGroupData['effectKeys']:
			var myEffectData = masterEffectData[effectKey] 
			var newEffect = null

			match myEffectData['type']:
				"DAMAGE":
					newEffect = DamageEffectResource.new( myEffectData , effectKey , self )
				"MOVEMENT":
					newEffect = MoveEffectResource.new( myEffectData , effectKey , self )
				"PASSIVE" :
					newEffect = PassiveEffectResource.new( myEffectData , effectKey , self )
				"HEALING":
					newEffect = HealEffectResource.new( myEffectData, effectKey , self )
		
			newEffectGroup.effects.append(newEffect)
		effectGroups.append(newEffectGroup)

func calculateSpecialProperties( props: Dictionary , object ):
	pass


# Ability API. IE these methods are meant to be consumed by other things
func getEffectGroups():
	return effectGroups.duplicate()

func getTargetAreaAsMatrix():
	return TARGET_MATRIX[targetAreaShown]

func rollAbility():
	# Loop through each effect and apply a roll
	pass

func executeAbility():
	pass
