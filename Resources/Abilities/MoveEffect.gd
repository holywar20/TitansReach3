extends EffectResource
class_name MoveEffectResource

const SUBTYPES = {
	"ANY" : "ANY" ,  
	"ANY_FULL" : "ANY_FULL" , 
	"ANY_EMPTY" : "ANY_EMPTY" , 
	"KNOCKBACK" : "KNOCKBACK" , 
	"PULL" : "PULL"
}

var movementSubtype = SUBTYPES.ANY_EMPTY
var movementAmount = 0

class Result:
	enum { MOVE , NOT_MOVE }
	
	var toHitRoll : int = 0

	var success : int = Result.MOVE
	var target : Vector2

func _init( moveEffectData : Dictionary , newKey : String , ability ):
	key = newKey
	type = EffectResource.TYPES.MOVEMENT
	parentAbility = ability

	if( "toPowerMod" in moveEffectData ):
		toPowerMod = moveEffectData.toPowerMod
	
	if( "toHitMod" in moveEffectData ):
		toHitMod = moveEffectData.toHitMod

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
	var result = Result.new()
	
	if( parentAbility.toHitTrait == "ALWAYS" ):
		result.toHitRoll = 200
	else:
		var traitVal : int = parentAbility.parentCharacter.getCurrentTrait( parentAbility.toHitTrait )
		var roll : int = int( randi() % 100 )
		var bonus = int( parentAbility.toHitBase + ( traitVal * TO_HIT_TRAIT_MULTIPLE ) * toHitMod )

		result.toHitRoll = roll + bonus

	return result
