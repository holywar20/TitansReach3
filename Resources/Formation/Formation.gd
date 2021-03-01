extends TitansResource
class_name FormationResource

# Note depth & width are reduced by 1, because of the zeroth index 
const WIDTH = 5
const DEPTH = 3

const DEFAULT_POSITIONS_ARRAY = [
	[true, true, true, true, true] ,
	[true, true, true, true, true] ,
	[true, true, true, true, true]
] 

enum FILTER_TYPE {
	VALID_TARGET_ROW
}

var positions = [
	[true, true, true, true, true] ,
	[true, true, true, true, true] ,
	[true, true, true, true, true]
]

var filteredPos = [
	[true, true, true, true, true] ,
	[true, true, true, true, true] ,
	[true, true, true, true, true]
]

var isPlayer = true

# Overrides
func get_class(): 
	return "FormationResource"

func is_class( name : String ): 
	return name == "FormationResource"

func _init( manyCrew = null , player : bool = true ):
	isPlayer = player

	if( manyCrew ):
		for crewman in manyCrew:
			fillEmpty( crewman )

# Management
func resetFilters():
	filteredPos = DEFAULT_POSITIONS_ARRAY.duplicate()

	for x in range(0, positions.size()):
		for y in range(0, positions[x].size()):
			filteredPos[x][y] = positions[x][y]

func fillEmpty( crewman : CharacterResource ):
	var isFilled = false
	var runCount = 0

	while !isFilled && runCount < 10:
		runCount = runCount + 1
		var x = randi() % DEPTH
		var y = randi() % WIDTH

		if typeof(positions[x][y]) == TYPE_BOOL:
			if( positions[x][y] == true ):
				positions[x][y] = crewman
				isFilled = true
				break

# Data retrevial
func getStringAtLocation( loc : Vector2 ) -> String:
	var myString = ""
	var variableObject = positions[loc.x][loc.y]

	match typeof(variableObject):
		TYPE_BOOL:
			myString = "Ground : " + str(loc.x) + " - "  +  str(loc.y)
		TYPE_OBJECT:
			match variableObject.get_class():
				"CharacterResource":
					myString = variableObject.getNickName()

	return myString

func isCharacterResource( loc : Vector2 ) -> bool:
	var isValid = false
	
	if typeof(positions[loc.x][loc.y]) == TYPE_OBJECT:
		if positions[loc.x][loc.y].is_class("CharacterResource"):
			isValid = true

	return isValid
	

# Formation Filters. Use these methods to modify filteredPos
# Filters out any target that isn't in the valid row
func isAnyValid():
	var isValid = false

	for x in range(0 , filteredPos.size() ):
		for y in range(0 , filteredPos[x].size() ):
			if( filteredPos[x][y] ):
				isValid = true

	return isValid

func filterValidTargetRow( validTargets : Array ):
	for x in range(0, filteredPos.size() ):
		if x in validTargets:
			continue
		else:
			for y in range( 0, filteredPos[x].size()):
				filteredPos[x][y] = false

# Returns a filtered array that has only battlers in it.
func filterIsABattler():
	for x in range(0 , filteredPos.size() ):
		for y in range(0 , filteredPos[x].size() ):
			if isCharacterResource( Vector2(x , y) ):
				continue # We are a character, so accept what is there.
			else:
				filteredPos[x][y] = false

func filterByTargetArea( targetArea : String , targetLoc : Vector2 ):	
	var targetMatrix = AbilityResource.TARGET_MATRIX[targetArea]
	
	# First, build a list of space actually under the target area. 
	var validSquares : Array = []
	for x in range(0 , targetMatrix.size()):
		for y in range(0, targetMatrix[x].size()):
			if( !targetMatrix[x][y]):
				continue # This is not included in the targeting solution. So discard. 

			# Get a clamped values to prevent out of bounds areas. Calculate where in target we are going.
			var realTarget = targetLoc + Vector2(-1, -1) + Vector2( x , y)
			if( realTarget.x >= 3 || realTarget.y >= 5 || realTarget.x < 0 || realTarget.y < 0):
				continue
			else:
				validSquares.append( realTarget )

	for x in range(0 , filteredPos.size() ):
		for y in range(0 , filteredPos[x].size() ):
			if validSquares.has( Vector2( x , y ) ) && isCharacterResource( Vector2(x, y) ):
				continue # We are in the targeting Array AND we are a character. Accept as valid.
			else:
				filteredPos[x][y] = false
				
func filterIsEmpty():
	for x in range(0, filteredPos.size() ):
		for y in range( 0, filteredPos[x].size() ):
			if( typeof(filteredPos[x][y]) == TYPE_OBJECT ):
				filteredPos[x][y] = false

# Filters out all but the current battler
func filterAllButSelf( battler : CharacterResource ):
	for x in range(0, filteredPos.size() ):
		for y in range( 0, filteredPos[x].size() ):
			if( typeof(filteredPos[x][y]) == TYPE_OBJECT ):
				if(battler == filteredPos[x][y]):
					continue
				else:
					filteredPos[x][y] = false
			else:
				filteredPos[x][y] = false

func getFilteredCharacters() -> Array:
	var characters = []
	
	for x in range(0 , filteredPos.size() ):
		for y in range(0, filteredPos[x].size() ):
			if( isCharacterResource( Vector2( x, y ) ) ):
				characters.append( filteredPos[x][y] )

	return characters


# Utility
func inverseValidTargets( validTargets : Array ) -> Array:
	# Need to invert if not a playerFormation because of how rows are counted
	var inverseValidTargets = []
	for target in validTargets:
		match int(target): # should be integers, but this breaks unless I do this for mysterous reasons.
			0 :
				inverseValidTargets.append(2)
			1 :
				inverseValidTargets.append(1)
			2 :
				inverseValidTargets.append(0)
	return inverseValidTargets

