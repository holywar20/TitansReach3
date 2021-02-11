extends EffectResource
class_name PassiveEffectResource

var mods : Dictionary

func _init( newEffectData : Dictionary , newKey : String ):
	mods = newEffectData['mods'].duplicate()

func get_class(): 
	return "PassiveEffectResource"

func is_class( name : String ): 
	return name == "PassiveEffectResource"
	
