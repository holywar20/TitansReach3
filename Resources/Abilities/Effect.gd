extends TitansResource
class_name EffectResource

const TYPES = {
	"MOVEMENT" : "MOVEMENT" , "DAMAGE" : "DAMAGE" , "HEALING" : "HEALING" , "PASSIVE" : "PASSIVE"
}

const NO_ANIMATION = "NONE"
const TO_HIT_TRAIT_MULTIPLE = 5

var key : String
var parentAbility = null
var type : String = ""
var effectAnimation : String = NO_ANIMATION
var toPowerMod = 1
var toHitMod = 1

# Each subclass has it's own result inner-class that handles it's unique properties and stores data about resolved rolls.
# Rolls are made indepenent of the target, and then compared to targets defensive values to determine amount of success.
# A roll is only made once for each target, but it is reused inside the battlemap
var result = null

func get_class(): 
	return "EffectResource"

func is_class( name : String ): 
	return name == "EffectResource"

func rollEffect():
	print("Ability of ", key , " is under construction!")