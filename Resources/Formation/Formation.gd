extends TitansResource
class_name FormationResource

# Note depth & width are reduced by 1, because of the zeroth index 
const WIDTH = 5
const DEPTH = 3

const DEFAULT_FILTER = [
	[true, true, true, true, true] ,
	[true, true, true, true, true] ,
	[true, true, true, true, true]
] 

var positions = [
	[false, false, false, false, false] ,
	[false, false, false, false, false] ,
	[false, false, false, false, false]
]

# Overrides
func get_class(): 
	return "FormationResource"

func is_class( name : String ): 
	return name == "FormationResource"

func _init( manyCrew : Array ):
	if( manyCrew ):
		for crewman in manyCrew:
			fillEmpty( crewman )

func fillEmpty( crewman : CharacterResource ):
	var isFilled = false
	var runCount = 0

	while !isFilled && runCount < 10:
		runCount = runCount + 1
		var x = randi() % DEPTH
		var y = randi() % WIDTH

		if !positions[x][y]:
			positions[x][y] = crewman
			isFilled = true
			break

# Returns all valid battlers in a single array
func getFilteredCharacterList( filterArray = null ) -> Array:
	if(!filterArray):
		filterArray = DEFAULT_FILTER
	
	var validBattlers = []
	
	for x in range(0 , filterArray.size() ):
		for y in range( 0, filterArray[x].size() ):
			if( filterArray[x][y] && positions[x][y] ):
				validBattlers.append( positions[x][y] )
		
	return validBattlers
