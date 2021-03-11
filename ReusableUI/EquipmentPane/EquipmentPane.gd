extends Panel

onready var slots = {
	CharacterResource.GEAR.EQUIP : [
		$PaperDoll/Equip1 , $PaperDoll/Equip2 , $PaperDoll/Equip3
	],
	CharacterResource.GEAR.ARMOR : [ 
		$PaperDoll/Armor 
	],
	CharacterResource.GEAR.WEAPON  : [
		$PaperDoll/Weapon1, $PaperDoll/Weapon2
	]
	
}

onready var charName = $CharName
onready var carryBar = $CarryBar

var character : CharacterResource

enum STATE {
	UNEQUIP , EQUIPMENT, ARMOR , WEAPONS
}
var state = STATE.UNEQUIP

func setupScene( newCharacter : CharacterResource ):
	updateUI( newCharacter )

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charName.set_text( character.getFullName() )

	var weightStatBlock = character.getWeightStatBlock()
	carryBar.setBarValues( weightStatBlock.total , weightStatBlock.current )

func _resetFocus():
	state = STATE.UNEQUIP

	for type in slots:
		for slot in slots[type]:
			slot.set_focus_mode( FOCUS_NONE )

# This seems useful. I should potentially put this somewhere reusable.
func setCircularFocusForArrayOfNodes( nodeArray : Array ):
	for x in range( 0, nodeArray.size() ):
		
		# make sure only these nodes can be focused.
		nodeArray[x].set_focus_mode( FOCUS_ALL )
		
		var nextTarget = posmod( x + 1 , nodeArray.size() )
		var prevTarget = posmod( x - 1 , nodeArray.size() )

		# Force all paths to loop on these nodes but no other.
		nodeArray[x].set_focus_neighbour( MARGIN_RIGHT , nodeArray[nextTarget].get_path() )
		nodeArray[x].set_focus_neighbour( MARGIN_TOP, nodeArray[nextTarget].get_path() ) 
		nodeArray[x].set_focus_next( nodeArray[nextTarget].get_path() )
		nodeArray[x].set_focus_neighbour( MARGIN_LEFT , nodeArray[prevTarget].get_path() )
		nodeArray[x].set_focus_neighbour( MARGIN_BOTTOM , nodeArray[prevTarget].get_path() )
		nodeArray[x].set_focus_previous( nodeArray[prevTarget].get_path() )


func delegateFocus( itemType = null ):
	_resetFocus()

	match itemType:
		ItemResource.ITEM_CATEGORY.EQUIPMENT:
			state = STATE.EQUIPMENT
			setCircularFocusForArrayOfNodes( slots[CharacterResource.GEAR.EQUIP] )
			
			slots[CharacterResource.GEAR.EQUIP][0].grab_focus()
			
		ItemResource.ITEM_CATEGORY.ARMOR:
			state = STATE.ARMOR
			setCircularFocusForArrayOfNodes( slots[CharacterResource.GEAR.ARMOR] )

			slots[CharacterResource.GEAR.ARMOR][0].grab_focus()

		ItemResource.ITEM_CATEGORY.WEAPON:
			state = STATE.WEAPONS
			setCircularFocusForArrayOfNodes( slots[CharacterResource.GEAR.WEAPON] )
			
			slots[CharacterResource.GEAR.WEAPON][0].grab_focus()

		null:
			# If we are null, user doesn't have an item selected, so allow free roam.
			for type in slots:
				for slot in slots[type]:
					if( slot.hasItem() ):
						slots.set_focus_mode( FOCUS_ALL )

# Signals
func _on_itemEquipped( type, slot ):
	if( character.canEquip( type, slot, slots[type][slot].item ) ):
		# Update new item count on character

		var oldItem = character.equipItem( type, slot, slots[type][slot] )
		
		if( oldItem ):
			# update old item count
			pass
			
		# Trigger big update with a signal

func _on_itemUnEquipped( type, slot ):
	print( type, slot )

func _on_userCancelled():
	delegateFocus( null )
