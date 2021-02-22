extends EffectResource
class_name HealEffectResource

var healLo = 0
var healHi = 0

func _init( healEffectData : Dictionary , newKey : String , ability ):
	# From Effect Resource 
	type = EffectResource.TYPES.HEALING
	key = newKey
	parentAbility = ability 

	if healEffectData.animation:
		animation = healEffectData.animation
	
	healLo = healEffectData.healLo
	healHi = healEffectData.healHi
	
class Result:
	var toHitTotal : int = 0
	var dmgRoll : int = 0

func get_class(): 
	return "HealEffectResource"

func is_class( name : String ): 
	return name == "HealEffectResource"

func rollEffect():
	var result = Result.new()