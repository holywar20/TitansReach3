extends Resource
class_name TitansResource

const ROUND_PRECISION = 1000
const SEED_SIZE = 100000000




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
