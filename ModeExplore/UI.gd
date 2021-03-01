extends CanvasLayer

signal userClosedMenu

func _unhandled_input( event : InputEvent ):
	if( event.is_action("ui_cancel") ):
		emit_signal("userClosedMenu")


