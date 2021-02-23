extends EffectResource
class_name MoveEffectResource

const SUBTYPES = {
	"ANY" : "ANY" , "KNOCKBACK" : "KNOCKBACK" , "PULL" : "PULL"
}

var movementSubtype = SUBTYPES.ANY
var movementAmount = 0

class Result:
	var toHitTotal : int = 0

func _init( moveEffectData : Dictionary , newKey : String , ability ):
	key = newKey
	type = EffectResource.TYPES.MOVEMENT
	parentAbility = ability

	if( "toEffectMod" in moveEffectData ):
		toEffectMod = moveEffectData.effectMod
	
	if( "toHitMod" in moveEffectData ):
		toHitMod = moveEffectData.effectMod

	if moveEffectData.effectAnimation:
		effectAnimation = moveEffectData.effectAnimation
	else:
		effectAnimation = EffectResource.NO_ANIMATION

	movementSubtype = moveEffectData.movementSubtype
	movementAmount = moveEffectData.movementAmount

func get_class(): 
	return "MoveEffectResource"

func is_class( name : String ): 
	return name == "MoveEffectResource"

func rollEffect():
	var result= Result.new()