extends Node
class_name EffectProvider

# Just a simple data container for all my effects so they can be easily retreived by name.
# This is a psuedostatic class. Doesn't store anything. It just gets data and builds scenes for you
#
# This is basically a factory. Simply attach node to what you want, wire up any data and go.

func get_class(): 
	return "EffectProvider"

func is_class( name : String ): 
	return name == "EffectProvider"

const EFFECTS = {
	"KINETIC_HIT" : "KINETIC_HIT" , 
	"DEFENSIVE": "DEFENSIVE" ,
	"MEDKIT": "MEDKIT",
}

const EFFECT_DATA = {
	EFFECTS.KINETIC_HIT : { 
		"scene" : "res://Effects/Target/ElementalHits/ElementalHit.tscn" ,
		"spriteFrameName" : "kinetic",
	},
	EFFECTS.MEDKIT : { 
		"scene" : "res://Effects/Target/Healing/Healing.tscn" ,
		"spriteFrameName" : "medkit",
	},
	EFFECTS.DEFENSIVE : {
		"scene" : "res://Effects/Target/Auras/Auras.tscn",
		"spriteFrameName" : "defend",
		"duration" : 0
	}
}

# Gets an effect that packs all the configuration stuff into the effect before it executes.
func getEffect( effectKey : String ) -> AnimatedSprite:
	var scene = load( EFFECT_DATA[effectKey].scene )
	# This will often error during effect construction. This is by design.
	# Check that all your paths are right. This means that EffectProvider can't find the scene.
	var effectInstance = scene.instance()
	effectInstance.set_animation( EFFECT_DATA[effectKey].spriteFrameName  )
	
	if( EFFECT_DATA[effectKey].has("duration") ):
		effectInstance.duration = EFFECT_DATA[effectKey].duration

	return effectInstance
