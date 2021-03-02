extends ItemResource
class_name CommodityResource

enum PATH { 
	BASIC , MINERALS
}
const FILES = {
	PATH.BASIC : "res://Generators/Data/Commodities/basic.json",
	PATH.MINERALS: "res://Generators/Data/Commodities/minerals.json"
}

func get_class(): 
	return "CommodityResource"

func is_class( name : String ): 
	return name == "CommodityResource"

func _init( key : String , path : int , amount : int ):
	fillableProps = [
		"itemKey",
		"itemType",
		"itemMass",
		"itemVolume",
		"itemValue",
		"itemDisplayName",
		"itemDisplayNameShort",
		"itemTexturePath",
		"itemTextureType",
		"itemRarity",
		"itemFloatCountable"
	]

	itemAmount = amount

	var filePath = FILES[path]
	var props = findKeyInJsonFile( key , filePath )

	# if not found, this will fail. This is on purpose
	flushAndFillProperties( props , self )
