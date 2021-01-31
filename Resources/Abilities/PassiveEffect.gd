extends EffectResource
class_name StatusEffect

func get_class(): 
	return "PassiveEffect"

func is_class( name : String ): 
    return name == "PassiveEffect"
    
var duration = 0 # If 99 , duration is permanent