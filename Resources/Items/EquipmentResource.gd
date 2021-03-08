extends ItemResource
class_name EquipmentResource

func get_class(): 
	return "EquipmentResource"

func is_class( name : String ): 
	return name == "EquipmentResource"


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
		"itemResource"
	]

	# if not found, this will fail. This is on purpose
	flushAndFillProperties( dbDictionary , self )

	itemIsCrewEquipable = true