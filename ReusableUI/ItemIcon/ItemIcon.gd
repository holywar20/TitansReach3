extends TextureButton

var myItem : ItemResource

onready var numOfItem : Label = $Label

enum STATE {
	FOCUS, NOT_FOCUS , SELECTED
}

const STATE_VARS = {
	STATE.FOCUS : Color( .3, 3 , .3 , 1),
	STATE.NOT_FOCUS : Color( 1 , 1 , 1 , 1),
	STATE.SELECTED : Color( .3 , .3 ,  1 , 1  )
}

var state = STATE.FOCUS

func setupScene( item : ItemResource ):
	myItem = item

	set_normal_texture( load( item.itemTexturePath ) )
	numOfItem.set_text( "x " + str(item.itemAmount) ) # TODO subtract out equipped amount

func setState( newState ):
	state = newState
	set_self_modulate( STATE_VARS[state] )

func _on_Item_focus_entered():
	setState( STATE.FOCUS )

func _on_Item_focus_exited():
	setState( STATE.NOT_FOCUS )

func _on_Item_pressed():
	setState( STATE.SELECTED )
