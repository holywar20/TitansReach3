extends ItemResource
class_name ArmorResource

func get_class(): 
	return "ArmorResource"

func is_class( name : String ): 
	return name == "ArmorResource"

func _init( dbDictionary : Dictionary ):
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
		"itemAmount",
		"itemCategory",
		"itemFloatCountable",
		"itemDescription"
	]

	# if not found, this will fail. This is on purpose
	flushAndFillProperties( dbDictionary , self )

	itemIsCrewEquipable = true