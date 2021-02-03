extends PanelContainer

onready var charIcon : TextureRect = $VBox/HBox/Icon
onready var charName : Label = $VBox/HBox/Name

var character : CharacterResource

func updateUI( newCharacter : CharacterResource ):
	character = newCharacter

	charIcon.set_texture(load(character.smallTexturePath))
	charName.set_text(character.getFullName())


