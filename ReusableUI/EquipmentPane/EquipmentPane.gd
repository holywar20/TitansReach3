extends Panel

onready var slots = {
	'equip1' : $PaperDoll/Equip1,
	'equip2' : $PaperDoll/Equip2,
	'equip3' : $PaperDoll/Equip3,
	'armor' : $PaperDoll/Armor,
	'weapon1' : $PaperDoll/Weapon1,
	'weapon2' : $PaperDoll/Weapon2
}

onready var charName = $CharName
onready var carryBar = $CarryBar

var character : CharacterResource

enum STATE {
	ALL , EQUIPMENT, ARMOR , WEAPONS, NONE
}
var state = STATE.ALL

signal equipmentAssignCancelled

func setupScene( newCharacter : CharacterResource ):
	updateUI( newCharacter )

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charName.set_text( character.getFullName() )

	var weightStatBlock = character.getWeightStatBlock()
	carryBar.setBarValues( weightStatBlock.total , weightStatBlock.current )

func _input( event ):
	# In this state we want to disallow anyone from leaving this node
	if( state == STATE.EQUIPMENT || state == STATE.ARMOR || state == STATE.WEAPONS ):
		if( event.is_action( "ui_cancel" ) ):
			get_tree().set_input_as_handled()
			delegateFocus( null )
			emit_signal( "equipmentAssignCancelled" )

func _resetFocus():
	state = STATE.NOT_FOCUS

	for key in slots:
		slots[key].set_focus_mode( FOCUS_NONE )

func delegateFocus( itemType = null ):
	_resetFocus()

	match itemType:
		ItemResource.ITEM_CATEGORY.EQUIPMENT:
			slots.equip1.set_focus_mode( FOCUS_ALL )
			slots.equip2.set_focus_mode( FOCUS_ALL )
			slots.equip3.set_focus_mode( FOCUS_ALL )

			slots.equip1.grab_focus()
		ItemResource.ITEM_CATEGORY.ARMOR:
			slots.armor.set_focus_mode( FOCUS_ALL )

			slots.armor.grab_focus()
		ItemResource.ITEM_CATEGORY.WEAPON:
			slots.weapon1.set_focus_mode( FOCUS_ALL )
			slots.weapon2.set_focus_mode( FOCUS_ALL )

			slots.weapon1.grab_focus()
		null:
			# If we are null, user doesn't have an item selected, so allow free roam.
			for key in slots:
				slots[key].set_focus_mode( FOCUS_ALL )

func _on_EquipmentPane_focus_entered():
	delegateFocus()
