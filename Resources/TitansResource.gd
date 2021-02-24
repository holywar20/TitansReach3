extends Resource
class_name TitansResource

const ROUND_PRECISION = 1000
const SEED_SIZE = 100000000
const RAND_KEY_SIZE = 10
const RAND_KEY_POSSIBLE_VALUES = 35
const RAND_SET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ012345689" 

var fillableProps = [] # Filled directly without modification
var isIntegers = [] # Any fillable prop that is also expected to be an integer. This forces a casting to that type
var percentDiffProps = []
var hiLoDiffProps = []
var percentChangeProps = []
var randomAssignmentProps = []

# Finds a random difference between two values. Used in procedural generation of values like mass, tempature, etc
func randDiffValues( low : int, hi : int ):
	hi 	= int( round( hi  * ROUND_PRECISION ) ) # To deal with fractions and modulo  Also this caps precision at 4 decimals
	low = int( round( low * ROUND_PRECISION ) )

	var diff = hi - low
	var random = null
	
	if( diff == 0 ):
		random = hi
	else:
		random = ( ( randi() % diff ) + low ) / ROUND_PRECISION

	return random

func randDiffIntegers( lo : int , hi : int ):
	var diff = hi - lo
	var random = null

	if( diff == 0):
		random = hi
	else:
		random = int( randi() % diff ) + lo

	return random

func randDiffPercents( low : int, high : int ):
	var random = randi()%100 + 1.0
	var diff = ( high - low ) * ( random / 100 )
	var newValue = diff + low
	
	return newValue

func genRandomSeed():
	return randi() % SEED_SIZE + 1

func genRandomKey():
	var myKey = ""
	
	for _x in range(0 , RAND_KEY_SIZE):
		var myKeyValue = randi()%RAND_KEY_POSSIBLE_VALUES
		myKey += RAND_SET[myKeyValue]
	
	return myKey

# Helper method for bulk assignment of properties
func flushAndFillProperties( props : Dictionary, object ):

	for key in fillableProps:
		if(props.has(key)):
			object[key] = props[key]

	for key in hiLoDiffProps:
		if(props.has(key)):
			object[key] = randDiffValues( props[key]['hi'] , props[key]['lo'] )
	
	for key in percentDiffProps:
		if(props.has(key)):
			object[key] = randDiffPercents( props[key]['hi'] , props[key]['lo'] )
	
	# Need to do integer casting because JSON typing handled dumbly
	for key in isIntegers:
		if( typeof(object[key]) == TYPE_ARRAY ):
			var integerArray : Array = []
			for elem in object[key]:
				integerArray.append( int( elem ) )
				
			object[key] = integerArray
		else:
			object[key] = int(object[key])


	for key in percentChangeProps:
		pass
	
	for key in randomAssignmentProps:
		pass
	
	object = calculateSpecialProperties( props , object )

	return object

# plugin meant for override
func calculateSpecialProperties( props: Dictionary , object ):
	return object

func makeArrayIntegers( anArray : Array ) -> Array:
	var newArray = []
	
	for elem in anArray:
		newArray.append( int(elem) )

	return anArray
