extends EffectResource
class_name MoveEffectResource

func _init( moveEffectData : Dictionary , newKey : String ):
	key = newKey

func get_class(): 
	return "MoveEffectResource"

func is_class( name : String ): 
	return name == "MoveEffectResource"