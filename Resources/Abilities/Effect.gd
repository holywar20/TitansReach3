extends TitansResource
class_name EffectResource

var key : String

const TARGET_AREA = {
	"SINGLE" : "SINGLE" ,"COLUMN" : "COLUMN", "ROW" : "ROW" , "CROSS" : "CROSS", "ALL" :  "ALL"
}

const TARGET_MATRIX = {
	TARGET_AREA.SINGLE : [[0 , 0 , 0] , [0 , 0 , 0] , [0 ,0 ,0]],
	TARGET_AREA.COLUMN : [[0 , 1 , 0] , [0 , 1 , 0] , [0 ,1 ,0]],
	TARGET_AREA.ROW    : [[0 , 1 , 0] , [0 , 1,  0 ] , [0 , 1 , 0]],
	TARGET_AREA.CROSS  : [[0 , 1 , 0] , [1 , 1 , 1 ] , [0 , 1 , 0]],
	TARGET_AREA.ALL    : [[1 , 1 , 1] , [1 , 1 , 1] , [1 , 1 , 1]]
}

# Effect State
var effectRolls 

# Effect Params
var targetArea = TARGET_AREA.SINGLE
var strengthPercent = 100 # Percentage effect is effective
var toHitPercent = 100
var alwaysHits = false

var casterAnimation = "BASIC_ATTACK"
var targetAnimation = "BASIC_DAMAGE"

func get_class(): 
	return "EffectResource"

func is_class( name : String ): 
	return name == "EffectResource"

func getTargetMatrix():
	return TARGET_MATRIX[targetArea]
