extends Node2D

var currentCharacter : CharacterResource

onready var nameLabel : Label = $Name
onready var characterSprite : Sprite = $Sprite
onready var pointer : Sprite = $Pointer

const OUTLINE_SHADER = preload("res://Shaders/OutlineShader.shader")

enum SELECTION {
	NONE, VIEW_TARGET, ATTACK_TARGET
}

var shaderParams = {
	SELECTION.NONE : {
		"width" : 1 , "outline_color" : Color(0,0,0,255)
	} ,
	SELECTION.VIEW_TARGET : {
		"width" : 1 , "outline_color" : Color(0,200,0,255)
	} ,
	SELECTION.ATTACK_TARGET : {
		"width" : 1 , "outline_color" : Color(200,0,0,255)
	} 
}

enum CURRENT {
	FOCUS,
	NOT_FOCUS
}

var selectionState = SELECTION.NONE
var focusState = CURRENT.NOT_FOCUS

func _updateShader( currentState ):
	var mat = characterSprite.get_material()
	mat.set_shader_param("width" , shaderParams[currentState].width )
	mat.set_shader_param("outline_color" , shaderParams[currentState].outline_color )

func setupScene( newCharacter : CharacterResource ):
	currentCharacter = newCharacter
	nameLabel.set_text( currentCharacter.getNickName() )
	
	# Set up outline shader. Shaders must be instanced in code.
	var mat = ShaderMaterial.new()
	mat.set_shader(OUTLINE_SHADER)
	mat.set_shader_param("width" , shaderParams[SELECTION.NONE].width )
	mat.set_shader_param("outline_color" , shaderParams[SELECTION.NONE].outline_color )
	characterSprite.set_material(mat)

# TODO probally need to redo this. Maybe add different independent sprites / particles to show state
func setSelectionState( state : int ):
	var selectionState = state
	_updateShader(selectionState)
	
	match selectionState:
		SELECTION.NONE:
			pass 
			#characterSprite.set_modulate( Color(255, 255, 255 , 255) )
		SELECTION.VIEW_TARGET:
			pass
			#characterSprite.set_modulate( Color(50, 200, 50 , 255) )
		SELECTION.ATTACK_TARGET:
			pass
			#characterSprite.set_modulate( Color(200, 50, 50 , 255) )

func setFocusState( state : int ):
	var focusState = state
	
	match focusState:
		CURRENT.FOCUS:
			pointer.set_visible(true)
		CURRENT.NOT_FOCUS:
			pointer.set_visible(false)
