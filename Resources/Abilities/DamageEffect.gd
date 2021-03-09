extends EffectResource
class_name DamageEffectResource

const DAMAGE_TYPES = {
	"KINETIC" : "KINETIC" , "TOXIC" : "TOXIC" , "THERMAL" : "THERMAL" , "EM" : "EM"
}

var dmgType = DAMAGE_TYPES.KINETIC

class Result:
	enum { MISS, HIT, CRITICAL }
	
	var toHitRoll : int = 0
	var dmgRoll : int = 0
	var dmgType = DAMAGE_TYPES.KINETIC

	var success = MISS

func _init( damageEffectData : Dictionary , newKey : String , ability ):
	# From Effect Resource 
	type = EffectResource.TYPES.DAMAGE
	key = newKey
	parentAbility = ability

	if( "toPowerMod" in damageEffectData ):
		toPowerMod = damageEffectData.toPowerMod
	
	if( "toHitMod" in damageEffectData ):
		toHitMod = damageEffectData.toHitMod

	if damageEffectData.effectAnimation:
		effectAnimation = damageEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION
	
	dmgType = damageEffectData.dmgType

func get_class(): 
	return "DamageEffectResource"

func is_class( name : String ): 
	return name == "DamageEffectResource"

func rollEffect():
	var result = Result.new()
	result.dmgType = dmgType

	if( parentAbility.toHitTrait == "ALWAYS" ):
		result.toHitRoll = 200
	else :
		var traitVal : int = 0
		if( parentAbility.toHitTrait != "NONE"):
			traitVal = parentAbility.parentCharacter.getCurrentTrait( parentAbility.toHitTrait )
		
		var roll : int = int( randi() % 100 )
		var bonus = int( parentAbility.toHitBase + ( traitVal * TO_HIT_TRAIT_MULTIPLE ) * toHitMod )
		# TODO - a hook for character level special bonus's potentially. Or have that work on traits alone?
		result.toHitRoll = roll + bonus

	var traitValue = 0
	if( parentAbility.toPowerTrait != "NONE" ):
		traitValue = parentAbility.parentCharacter.getCurrentTrait( parentAbility.toPowerTrait )
	# TODO - a hook for character level special bonus's potentially. Or have that work on traits alone?	
	var modDmgHi = ( traitValue + parentAbility.powerHiBase ) * toPowerMod
	var modDmgLo = ( traitValue + parentAbility.powerLoBase ) * toPowerMod

	result.dmgRoll = randDiffValues( modDmgLo, modDmgHi )

	return result
	
