extends EffectResource
class_name PassiveEffectResource

func get_class(): 
	return "PassiveEffectResource"

func is_class( name : String ): 
    return name == "PassiveEffectResource"
    
var duration = 0 # If 99 , duration is permanent