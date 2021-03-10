extends TextureButton

var myItem : ItemResource

onready var numOfItem : Label = $Label

enum STATE {
	FOCUS, NOT_FOCUS
}

const STATE_VARS = {
	STATE.FOCUS : Color( .3, 3 , .3 , 1),
	STATE.NOT_FOCUS : Color( 1 , 1 , 1 , 1)
}

func setupScene( item : ItemResource ):
	myItem = item

	set_normal_texture( load( item.itemTexturePath ) )
	numOfItem.set_text( "x " + str(item.itemAmount) ) # TODO subtract out equipped amount

func _on_Item_focus_entered():
	set_self_modulate( STATE_VARS[STATE.FOCUS] )

func _on_Item_focus_exited():
	set_self_modulate( STATE_VARS[STATE.NOT_FOCUS] )
