extends EffectResource
class_name HealEffectResource

func _init( healEffectData : Dictionary , newKey : String , ability ):
	# From Effect Resource 
	type = EffectResource.TYPES.HEALING
	key = newKey
	
	parentAbility = ability 

	if( "toPowerMod" in healEffectData ):
		toPowerMod = healEffectData.toPowerMod
	
	if( "toHitMod" in healEffectData ):
		toHitMod = healEffectData.toHitMod

	if healEffectData.effectAnimation:
		effectAnimation = healEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION

class Result:
	enum { HEALING , MISS }

	var toHitRoll : int = 0
	var healRoll : int = 0

	var success = MISS

func get_class(): 
	return "HealEffectResource"

func is_class( name : String ): 
	return name == "HealEffectResource"

func rollEffect():
	var result = Result.new()
	
	if( parentAbility.toHitTrait == "ALWAYS" ):
		result.toHitRoll = 200
	else:
		var traitVal : int = parentAbility.parentCharacter.getCurrentTrait( parentAbility.toHitTrait )
		var roll : int = int( randi() % 100 )
		var bonus = int( parentAbility.toHitBase + ( traitVal * TO_HIT_TRAIT_MULTIPLE ) * toHitMod )
		# TODO - a hook for character level special bonus's potentially. Or have that work on traits alone?
		result.toHitRoll = roll + bonus

	var traitValue = 0
	if( parentAbility.toPowerTrait != "NONE" ):
		traitValue = parentAbility.parentCharacter.getCurrentTrait( parentAbility.toPowerTrait )
	# TODO - a hook for character level special bonus's potentially. Or have that work on traits alone?	
	var modHealHi = ( traitValue + parentAbility.powerHiBase ) * toPowerMod
	var modHealLo = ( traitValue + parentAbility.powerLoBase ) * toPowerMod

	result.healRoll = randDiffValues( modHealHi, modHealLo )

	return result
