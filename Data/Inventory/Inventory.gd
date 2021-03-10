extends Node


# TODO : should be deterimined dynamically based on ship data or mods
var volumeCapacity = 2000
var massCapacity = 1000000

var allItems = {}
var db

func setupData( newDb ):
	db = newDb

	# Load intially owned items based on the current save
	_loadOwnedItems()

func _loadOwnedItems():
	# Blank out current item list, as we are using DB as source of truth now.
	allItems = {}

	var getAll : String = """
		SELECT * FROM CommodityResource WHERE itemAmount > 0
	"""
	var success = db.query( getAll )

	# First we just build up a key array of all the guys we care about
	if( success ):
		var keyDictionary : Dictionary = {
			ItemResource.ITEM_TYPE.COMMODITY : [],
			ItemResource.ITEM_TYPE.WEAPON : [],
			ItemResource.ITEM_TYPE.ARMOR : [],
			ItemResource.ITEM_TYPE.EQUIPMENT : []
		}

		for result in db.query_result:
			keyDictionary[result.itemType].append( result.id )

		# Then populate based on the keyword filter. Note each type will have it's own sql so we can do itemType specific joins
		for itemType in keyDictionary:
			retreiveItemsByType( itemType , keyDictionary[itemType] )		

func retreiveItemsByType( itemType : String , keyFilter : Array ,  propFilter : Dictionary = {} ):
	var joinFragment = ""
	var selectFragment = "SELECT * FROM CommodityResource "
	var bigString = PoolStringArray(keyFilter).join(" , ")
	var whereFragment = "WHERE CommodityResource.id IN ( " + bigString + " ) "

	match itemType:
		ItemResource.ITEM_TYPE.COMMODITY:
			pass
		ItemResource.ITEM_TYPE.ARMOR :
			pass
		ItemResource.ITEM_TYPE.EQUIPMENT :
			pass
		ItemResource.ITEM_TYPE.WEAPON :
			pass
	
	var query = selectFragment + joinFragment + whereFragment
	var success = db.query( query )

	for result in db.query_result:
		match itemType:
			ItemResource.ITEM_TYPE.COMMODITY:
				allItems[result.itemKey] = CommodityResource.new( result )
			ItemResource.ITEM_TYPE.ARMOR :
				allItems[result.itemKey] = ArmorResource.new( result )
			ItemResource.ITEM_TYPE.EQUIPMENT :
				allItems[result.itemKey] = EquipmentResource.new( result )
			ItemResource.ITEM_TYPE.WEAPON :
				allItems[result.itemKey] = WeaponResource.new( result )


func destroyItems():
	pass

func getItemsByType( itemType : String , _onlyEquippedItems = false ):
	var itemArray : Array = []

	for key in allItems:
		if( allItems[key].itemType == itemType ):
			itemArray.append( allItems[key] )
			# TODO add flag for filtering only equipped items
	
	return itemArray
		
func getItem( itemKey : String ):
	if( allItems.has(itemKey) ):
		return allItems[itemKey]
	else:
		return null

func getTotalValue():
	var value : float = 0

	for key in allItems:
		value += allItems[key].itemAmount * allItems[key].itemValue

	return value

func getTotalValueAsString():
	return str( getTotalValue() ) + " ink"
	
func getTotalMass():
	var value : float = 0

	for key in allItems:
		value += allItems[key].itemAmount * allItems[key].itemMass

	return value

func getTotalMassAsString():
	pass

func getTotalVolume():
	var value : float = 0

	for key in allItems:
		value += allItems[key].itemAmount * allItems[key].itemVolume

	return value

func getTotalVolumeAsString():
	pass
