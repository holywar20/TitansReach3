extends VBoxContainer

var itemIconScene = preload("res://ReusableUI/ItemIcon/ItemIcon.tscn")

var inventory : Node 

onready var itemBase = $Container/Panel/Grid

signal itemSelected( item )
signal itemFocused( item )
signal itemNotFocused( item )

const ITEM_DISPLAY_PROPS = {
	ItemResource.ITEM_TYPE.ARMOR : {
		'columnNum' : 5
	},
	ItemResource.ITEM_TYPE.EQUIPMENT : {
		"columnNum" : 5
	},
	ItemResource.ITEM_TYPE.WEAPON : {
		"columnNum" : 3
	}
}

func setupScene( newInventory  ):
	inventory = newInventory
	updateUI( ItemResource.ITEM_TYPE.WEAPON ) # Weapons are pressed by default

func updateUI( itemType ):
	var displayItems = inventory.getItemsByType( itemType )

	itemBase.set_columns( ITEM_DISPLAY_PROPS[itemType].columnNum )

	for child in itemBase.get_children():
		child.queue_free()

	for item in displayItems:
		var iconInstance = itemIconScene.instance()
		
		itemBase.add_child( iconInstance )
		iconInstance.setupScene( item )
		
		iconInstance.connect( "pressed" , self , "_on_ItemIcon_pressed" , [iconInstance.myItem] )
		iconInstance.connect( "focus_entered" , self , "_on_ItemIcon_itemFocused", [iconInstance.myItem] )
		iconInstance.connect( "focus_exited" , self , "_on_ItemIcon_itemNotFocused", [iconInstance.myItem] )

# Called by parent something goes wrong and we need to go back to previous state
func backToSelection():
	for child in itemBase.get_children():
		if( child.state == child.STATE.SELECTED ):
			child.grab_focus()
			child.setState( child.STATE.FOCUS )



# Called whenenever we need to clear a selection
func _resetItemIcons():
	for child in itemBase.get_children():
		child.setState( child.STATE.NOT_FOCUS )

# Signals
func _on_Weapons_toggled( _button_pressed ):
	updateUI( ItemResource.ITEM_TYPE.WEAPON )

func _on_Armor_toggled( _button_pressed ):
	updateUI( ItemResource.ITEM_TYPE.ARMOR )

func _on_Equipment_toggled( _button_pressed ):
	updateUI( ItemResource.ITEM_TYPE.EQUIPMENT )

func _on_ItemIcon_itemFocused( item : ItemResource ):
	emit_signal( "itemFocused", item )

func _on_ItemIcon_itemNotFocused( item: ItemResource):
	emit_signal( "itemNotFocused" , item )
	
func _on_ItemIcon_pressed( item: ItemResource ):
	emit_signal( "itemSelected" , item )
