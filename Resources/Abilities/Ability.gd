extends TitansResource
class_name AbilityResource

var masterEffectData = {
	"DEFEND" : { # Passive abilities will mirror the character and be swapped in as a mod, 1 for 1.
		"type" : "PASSIVE",
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
		"allowedDirection" : "ANY",
		"allowedRange" : 5
	},
	"KINETIC_ATTACK_EFFECT" : {
		"type" : "DAMAGE",
		"animation" : "unset",
		"dmgType" : "KINETIC",
		"dmgHi" : 3,
		"dmgLo" : 5
	}
}
const TARGET_AREA = {
	"SINGLE" : "SINGLE" ,"COLUMN" : "COLUMN", "ROW" : "ROW" , "CROSS" : "CROSS", "ALL" :  "ALL"
}
const TARGET_TYPE = {
	"ALLY_FLOOR" : "ALLY_FLOOR" , "ALLY_UNIT" : "ALLY_UNIT", "ENEMY_UNIT" : "ENEMY_UNIT", "ENEMY_FLOOR" : "ENEMY_FLOOR", "SELF" : "SELF"
}
const ABILITY_TYPE = {
	"ACTION" : "ACTION" , "STANCE" : "STANCE" , "INSTANT" : "INSTANT"
}

const TARGET_MATRIX = {
	TARGET_AREA.SINGLE : [[0 , 0 , 0] , [0 , 0 , 0] , [0 ,0 ,0]],
	TARGET_AREA.COLUMN : [[0 , 1 , 0] , [0 , 1 , 0] , [0 ,1 ,0]],
	TARGET_AREA.ROW    : [[0 , 1 , 0] , [0 , 1,  0 ] , [0 , 1 , 0]],
	TARGET_AREA.CROSS  : [[0 , 1 , 0] , [1 , 1 , 1 ] , [0 , 1 , 0]],
	TARGET_AREA.ALL    : [[1 , 1 , 1] , [1 , 1 , 1] , [1 , 1 , 1]]
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

var effectGroups : Array = [] # An array of EffectGroup

class EffectGroup:	
	var targetType : String = TARGET_TYPE.SELF
	var targetArea : String = TARGET_AREA.SINGLE
	var selected = null # This is meant to be a FormationResource.
	var effects : Array = []

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
	_makeEffects( abilityTable[key]['effectGroups'] )

func _makeEffects( newEffectGroups : Array ):
	for effectGroupData in newEffectGroups:
		var newEffectGroup = EffectGroup.new()
		newEffectGroup.targetType = effectGroupData['targetType']

		for effectKey in effectGroupData['effectKeys']:
			var myEffectData = masterEffectData[effectKey] 
			var newEffect = null

			match myEffectData['type']:
				"DAMAGE":
					newEffect = DamageEffectResource.new( myEffectData , effectKey )
				"MOVEMENT":
					newEffect = MoveEffectResource.new( myEffectData , effectKey )
				"PASSIVE" :
					newEffect = PassiveEffectResource.new( myEffectData , effectKey )
		
			newEffectGroup.effects.append(newEffect)
		effectGroups.append(newEffectGroup)

func calculateSpecialProperties( props: Dictionary , object ):
	pass

# Ability API. IE these methods are meant to be consumed by other things
func getEffectGroups():
	return effectGroups.duplicate()

func rollAbility():
	# Loop through each effect and apply a roll
	pass

func executeAbility():
	pass
