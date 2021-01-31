extends Node

func bubbleSortArrayByDictKey( arrayToSort : Array, dictKey : String, invert = null ):
	var swap = null
	var performedASwap = false
	var stayInLoop = true

	while( stayInLoop == true ):
		for i in range(0 , arrayToSort.size()-1 ):
			if( arrayToSort[i][dictKey] > arrayToSort[i+1][dictKey] ):
				swap = arrayToSort[i]
				arrayToSort[i] = arrayToSort[i+1]
				arrayToSort[i+1] = swap
				performedASwap = true
		
		if( performedASwap == true ):
			performedASwap = false
		else:
			stayInLoop = false
		
	if( invert ):
		arrayToSort.invert()

	return arrayToSort
