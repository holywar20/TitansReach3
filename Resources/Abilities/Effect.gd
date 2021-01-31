extends TitansResource
class_name EffectResource

const TARGET_AREA = {
	"SELF" 	: "SELF" , "SINGLE" : "SINGLE" ,"COLUMN" : "COLUMN", "ROW" 	: "ROW" , "ROW_DECAY" : "ROW_DECAY", "CROSS" : "CROSS", "ALL" :  "ALL"
}

# Effect State
var effectRolls 

# Effect Params
var targetArea = TARGET_AREA.self
var strengthPercent = 100 # Percentage effect is effective
var toHitPercent = 100
var alwaysHits = false

var casterAnimation = "BASIC_ATTACK"
var targetAnimation = "BASIC_DAMAGE"

func get_class(): 
	return "EffectResource"

func is_class( name : String ): 
	return name == "EffectResource"