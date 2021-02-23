extends EffectResource
class_name PassiveEffectResource

# This dictionary is meant to mirror the character tree, so we can do a recursive find & replace on all modifications
var mods : Dictionary

func _init( passiveEffectData : Dictionary , newKey : String , ability ):
	type = EffectResource.TYPES.PASSIVE
	key = newKey
	parentAbility = ability

	if( "toEffectMod" in passiveEffectData ):
		toEffectMod = passiveEffectData.toEffectMod
	
	if( "toHitMod" in passiveEffectData ):
		toHitMod = passiveEffectData.toHitMod

	if passiveEffectData.effectAnimation:
		effectAnimation = passiveEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION

	mods = passiveEffectData['mods'].duplicate()

class Result:
	var toHitRoll : int = 0	

func get_class(): 
	return "PassiveEffectResource"

func is_class( name : String ): 
	return name == "PassiveEffectResource"
	
func rollEffect():
	var result = Result.new()

	return result