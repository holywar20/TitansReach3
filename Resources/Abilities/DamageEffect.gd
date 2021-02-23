extends EffectResource
class_name DamageEffectResource

const DAMAGE_TYPES = {
	"KINETIC" : "KINETIC" , "TOXIC" : "TOXIC" , "THERMAL" : "THERMAL" , "EM" : "EM"
}

var dmgType = DAMAGE_TYPES.KINETIC
var dmgHi = 0
var dmgLo = 0

class Result:
	var toHitRoll : int = 0
	var dmgRoll : int = 0

func _init( damageEffectData : Dictionary , newKey : String , ability ):
	# From Effect Resource 
	type = EffectResource.TYPES.DAMAGE
	key = newKey
	parentAbility = ability

	if( "effectMod" in damageEffectData ):
		toEffectMod = damageEffectData.effectMod
	
	if( "toHitMod" in damageEffectData ):
		toHitMod = damageEffectData.effectMod

	if damageEffectData.effectAnimation:
		effectAnimation = damageEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION
	
	dmgType = damageEffectData.dmgType
	dmgHi = damageEffectData.dmgHi
	dmgLo = damageEffectData.dmgLo


func get_class(): 
	return "DamageEffectResource"

func is_class( name : String ): 
	return name == "DamageEffectResource"

func rollEffect():
	var result = Result.new()
