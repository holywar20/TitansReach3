extends EffectResource
class_name HealEffectResource

func _init( healEffectData : Dictionary , newKey : String , ability ):
	# From Effect Resource 
	type = EffectResource.TYPES.HEALING
	key = newKey
	
	parentAbility = ability 

	if( "toEffectMod" in healEffectData ):
		toEffectMod = healEffectData.toEffectMod
	
	if( "toHitMod" in healEffectData ):
		toHitMod = healEffectData.toHitMod

	if healEffectData.effectAnimation:
		effectAnimation = healEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION

class Result:
	var toHitTotal : int = 0
	var dmgRoll : int = 0

func get_class(): 
	return "HealEffectResource"

func is_class( name : String ): 
	return name == "HealEffectResource"

func rollEffect():
	var result = Result.new()
	# var baseDmg = randDiffValues(healLo, healHi)