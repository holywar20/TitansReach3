extends Label
class_name BattlerMessage

enum MESSAGE_TYPE {
	DAMAGE, HEALING , CRITICAL , MISS
}

var MESSAGE_EFFECTS =  {
	MESSAGE_TYPE.DAMAGE : {
		"color" : Color( .65 , .65 , 0 , 1)
	} ,
	MESSAGE_TYPE.HEALING : {
		"color" : Color( 0 , 0 , .64 , 1 )
	} ,
	MESSAGE_TYPE.CRITICAL : {
		"color" : Color( 0 , .65 , .65 , 1)
	} ,
	MESSAGE_TYPE.MISS : {
		"color" : Color( .65 , 0 , 0 , 1)
	}
}

func get_class(): 
	return "DamageEffectResource"

func is_class( name : String ): 
	return name == "DamageEffectResource"

func setupScene( type : int , message : String):
	set_text( str(message) )
	set_self_modulate( MESSAGE_EFFECTS[type].color )
	show()

func _on_Timer_timeout():
	queue_free()
