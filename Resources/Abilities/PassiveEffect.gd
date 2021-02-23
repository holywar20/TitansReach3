extends EffectResource
class_name PassiveEffectResource

var mods : Dictionary

func _init( newEffectData : Dictionary , newKey : String , ability ):
	type = EffectResource.TYPES.PASSIVE
	key = newKey
	parentAbility = ability

	if newEffectData.effectAnimation:
		effectAnimation = newEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION

	mods = newEffectData['mods'].duplicate()

class Result:
	var toHitTotal : int = 0

func get_class(): 
	return "PassiveEffectResource"

func is_class( name : String ): 
	return name == "PassiveEffectResource"
	
func rollEffect():
	var result = Result.new()

	return result