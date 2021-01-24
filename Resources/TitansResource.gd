extends Resource
class_name TitansResource

const ROUND_PRECISION = 1000
const SEED_SIZE = 100000000

var fillableProps = []
var percentDiffProps = []
var hiLoDiffProps = []


# Finds a random difference between two values. Used in procedural generation of values like mass, tempature, etc
func randDiffValues( low, hi ):
	hi 	= int( round( hi  * ROUND_PRECISION ) ) # To deal with fractions and modulo  Also this caps precision at 4 decimals
	low = int( round( low * ROUND_PRECISION ) )

	var diff = hi - low
	var random = null
	
	if( diff == 0 ):
		random = hi
	else:
		random = ( randi() % diff + low ) / ROUND_PRECISION
	
	return random

func randDiffPercents( low , high ):
	var random = randi()%100 + 1.0
	var diff = ( high - low ) * ( random / 100 )
	var newValue = diff + low
	
	return newValue

func genRandomSeed():
	return randi() % SEED_SIZE + 1

# Helper method for bulk assignment of properties
func flushAndFillProperties( props : Dictionary, object ):

	for key in fillableProps:
		object[key] = props[key]

	for key in hiLoDiffProps:
		object[key] = randDiffValues( props[key]['hi'] , props[key]['lo'] )
	
	for key in percentDiffProps:
		object[key] = randDiffPercents( props[key]['hi'] , props[key]['lo'] )
	
	object = localFlushAndFillProperties( props , object )

	return object

# plugin meant for override
func localFlushAndFillProperties( props: Dictionary , object ):
	return object
