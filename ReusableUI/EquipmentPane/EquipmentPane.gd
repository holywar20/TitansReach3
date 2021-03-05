extends Panel

onready var equip1 = $PaperDoll/Equip1
onready var equip2 = $PaperDoll/Equip2
onready var equip3 = $PaperDoll/Equip3
onready var armor = $PaperDoll/Armor
onready var weapon1 = $PaperDoll/Weapon1
onready var weapon2 = $PaperDoll/Weapon2

onready var charName = $CharName

onready var carryBar = $CarryBar

var character : CharacterResource

func setupScene( newCharacter : CharacterResource ):
	updateUI( newCharacter )

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charName.set_text( character.getFullName() )

	var weightStatBlock = character.getWeightStatBlock()
	carryBar.setBarValues( weightStatBlock.total , weightStatBlock.current ) 
