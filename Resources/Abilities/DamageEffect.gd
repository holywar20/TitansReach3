extends EffectResource
class_name DamageEffectResource

func _init( damageEffectData : Dictionary , newKey : String):
	pass

func get_class(): 
	return "DamageEffectResource"

func is_class( name : String ): 
	return name == "DamageEffectResource"
