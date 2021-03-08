extends TitansResource
class_name ItemResource

# Storage class for Items.
# NOTE this class should never be instanced on it's own. It's just meant to be parent class for all items

# Texture grid size , used for determining Lock & Icon size in UI, meant to give equipment a distinct but simple profile
const TEXTURE_GRID_TYPE = {
	"BIG_SINGLE" : "BIG_SINGLE" ,
	"SINGLE" : "SINGLE", 
	"ROW" : "ROW", 
	"COL" : "COL", 
}

const ITEM_CATEGORY = {
	"VOLITILE" : "VOLITILE",
	"MINERAL" : "MINERAL",
	# Equipables
	"WEAPON"  : "WEAPON",
	"ARMOR" : "ARMOR",
	"EQUIPMENT" : "EQUIPMENT"
} 

const ITEM_TYPE = {
	"COMMODITY" : "COMMODITY",
	# Equipables
	"WEAPON"  : "WEAPON",
	"ARMOR" : "ARMOR",
	"EQUIPMENT" : "EQUIPMENT"
}

# Metadata universal to all items
var itemMass : float = 0.0
var itemVolume : float = 0
var itemValue :float  = 0
var itemDisplayName : String = "Unassigned"
var itemDisplayNameShort : String = "Unassigned"
var itemKey : String = "Unassigned"
var itemTextureType : String = TEXTURE_GRID_TYPE.SINGLE
var itemTexturePath : String = "res://icon.png"
var itemAmount : float = 0.0
var itemType : String = ITEM_TYPE.COMMODITY
var itemFloatCountable = false # If true, allow subtraction & float changes. otherwise treat as integer
var itemCategory : String = ITEM_CATEGORY.VOLITILE
var itemDescription : String = "No description"

# Meta that applies to crew equipable items
var itemIsCrewEquipable = false
var itemCarryWeight = 0
var itemRarity = RARITY.COMMON


const RARITY = {
	"COMMON" : "COMMON" , "UNCOMMON" : "UNCOMMON" , "RARE" : "RARE" , "LEGENDARY" : "LEGENDARY" , "UNIQUE" : "UNIQUE"
}
const RARITY_DATA =  { 
	"COMMON" : { 
		"String" : "Common" ,
		"Color" : Color(0 ,0 ,0 ,0) 
	},
	"UNCOMMON" : { 
		"String" : "Uncommon" ,
		"Color" : Color(0 ,0 ,0 ,0) 
	} , 
	"RARE" : { 
		"String" : "Rare" 	,
		"Color" : Color(0 ,0 ,0 ,0) 
	},
	"LEGENDARY" :	{ 
		"String" : "Legendary",
		"Color" : Color(0 ,0 ,0 ,0) }, 
	"UNIQUE" :{ 
		"String" : "Unique"	,
		"Color" : Color(0 ,0 ,0 ,0) 
	}
}

func get_class(): 
	return "ItemResource"

func is_class( name : String ): 
	return name == "ItemResource"

func getItemDisplay( short = false ):
	if( short ):
		return itemDisplayNameShort
	else:
		return itemDisplayName

func getMassDisplay():
	return str( itemMass ) + " Kg"

func getAllMassDisplay():
	return str( itemMass * itemAmount ) + " Kg"

func getVolumeDisplay():
	return str( itemVolume ) + " m3"

func getAllVolumeDisplay():
	return str( itemVolume * itemAmount )

func getItemValueDisplay():
	return str( itemValue ) + " Ink"

func getAllItemValueDisplay():
	return str( itemValue * itemAmount )

# meant to be overridden. Should return an array of strings.
func getAbilities():
	return []
