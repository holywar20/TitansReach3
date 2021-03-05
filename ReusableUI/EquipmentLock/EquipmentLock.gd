extends PanelContainer

enum LOCK_TYPE{
	WEAPON , ARMOR , EQUIPMENT , SHIP_MODULE
}
const LOCK_PROPS = {
	LOCK_TYPE.WEAPON : {
		"size" : Vector2( 128 , 64 ),
		"title" : "Weapon",
		"placeholderIcon" : preload("res://AssettsImage/Items/Weapons/TerranPistol.jpg")
	},
	LOCK_TYPE.ARMOR : {
		"size" : Vector2( 64 , 128 ),
		"title" : "Armor" ,
		"placeholderIcon" : preload("res://AssettsImage/Items/Frames/TerranLightFrame.jpg")
	},
	LOCK_TYPE.EQUIPMENT : {
		"size" : Vector2( 64 , 64 ),
		"title" : "Equip.",
		"placeholderIcon" : preload("res://AssettsImage/Items/Equipment/TerranFragGrenade.jpg")
	},
	LOCK_TYPE.SHIP_MODULE : {
		"size" : Vector2( 128 , 128 ),
		"title" : "Module",
		"placeholderIcon" : ""
	}
}

const PLACE_HOLDER_COLOR = Color(.1, .1 , .1 ,  1 )

onready var texture : TextureRect = $VBox/TextureRect
onready var label : Label = $VBox/Label

export(LOCK_TYPE) var lockType = LOCK_TYPE.EQUIPMENT

var item = null

func _ready():
	texture.rect_min_size = LOCK_PROPS[lockType].size
	texture.set_texture( LOCK_PROPS[lockType].placeholderIcon )

	label.set_text( LOCK_PROPS[lockType].title )

func setItem():
	pass
	# Confirm item is valid.
	# If Valid set label to short name
	# Else bubble an error message with sigals


