extends PanelContainer

enum LOCK_TYPE{
	WEAPON , ARMOR , EQUIPMENT , SHIP_MODULE
}
# Charactor.GEAR and LOCK_TYPE should be the same value
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
export var lockSlot : int = 0

var item = null

signal userEquippedItem(lockType, slot)
signal userUnequippedItem(lockType, slot)
signal userCancelled()

enum STATE {
	FOCUS, NOT_FOCUS
}

const STATE_VARS = {
	STATE.FOCUS : Color( 0 , 1 , 0 , 1),
	STATE.NOT_FOCUS : Color( 1 , 1, 1 , 1)
}

func _input( event ):
	if( has_focus() ):
		if( event.is_action_pressed("ui_accept") ):
			emit_signal( "userEquippedItem" , LOCK_TYPE.WEAPON , lockSlot )
			get_tree().set_input_as_handled()

		if( event.is_action_pressed("ui_cancel") ):
			if( hasItem() ):
				emit_signal("userUnequippedItem" , LOCK_TYPE.WEAPON , lockSlot )
			else:
				emit_signal("userCancelled")

			get_tree().set_input_as_handled()

func _ready():
	texture.rect_min_size = LOCK_PROPS[lockType].size
	texture.set_texture( LOCK_PROPS[lockType].placeholderIcon )

	label.set_text( LOCK_PROPS[lockType].title )

func setItem():
	pass

func hasItem():
	return true if item else false


# Signal responses
func _on_EquipmentLock_focus_entered():
	set_self_modulate( STATE_VARS[STATE.FOCUS] )

func _on_EquipmentLock_focus_exited():
	set_self_modulate( STATE_VARS[STATE.NOT_FOCUS] )


