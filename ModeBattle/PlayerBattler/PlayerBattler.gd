extends Node2D
class_name Battler

var currentCharacter : CharacterResource

onready var nameLabel : Label = $Name
onready var characterSprite : Sprite = $Sprite
onready var pointer : Sprite = $Pointer

const OUTLINE_SHADER = preload("res://Shaders/OutlineShader.shader")

enum SELECTION {
	NONE, FOCUS_TARGET, ASSIST_TARGET, ATTACK_TARGET
}

var shaderParams = {
	SELECTION.NONE : {
		"width" : 1 , "outline_color" : Color(0,0,0,255)
	} ,
	SELECTION.FOCUS_TARGET : {
		"width" : 3 , "outline_color" : Color(0,200,0,255)
	} ,
	SELECTION.ASSIST_TARGET : {
		"width" : 3 , "outline_color" : Color(0,0,200,255)
	} ,
	SELECTION.ATTACK_TARGET : {
		"width" : 3 , "outline_color" : Color(200,0,0,255)
	}
}

enum STATE {
	FOCUS,
	NOT_FOCUS
}

var currentFormationLocation = Vector2(0,0)
var selectionState = SELECTION.NONE
var focusState = STATE.NOT_FOCUS

func _updateShader( currentState ):
	var mat = characterSprite.get_material()
	mat.set_shader_param("width" , shaderParams[currentState].width )
	mat.set_shader_param("outline_color" , shaderParams[currentState].outline_color )

func setupScene( newCharacter : CharacterResource , newLocation : Vector2 ):
	currentCharacter = newCharacter
	currentFormationLocation = newLocation

	nameLabel.set_text( currentCharacter.getNickName() )
	
	# Set up outline shader. Shaders must be instanced in code.
	var mat = ShaderMaterial.new()
	mat.set_shader(OUTLINE_SHADER)
	mat.set_shader_param("width" , shaderParams[SELECTION.NONE].width )
	mat.set_shader_param("outline_color" , shaderParams[SELECTION.NONE].outline_color )
	characterSprite.set_material(mat)

# TODO probally need to redo this. Maybe add different independent sprites / particles to show state
func setSelectionState( state : int ):
	selectionState = state
	
	print( selectionState )


	match selectionState:
		SELECTION.NONE:
			if( focusState == STATE.FOCUS ):
				selectionState = SELECTION.FOCUS_TARGET
		SELECTION.FOCUS_TARGET:
			pass
		SELECTION.ASSIST_TARGET:
			pass
		SELECTION.ATTACK_TARGET:
			pass

	_updateShader(selectionState)

func setFocusState( state : int ):
	focusState = state
	
	match focusState:
		STATE.FOCUS:
			pointer.set_visible(true)
		STATE.NOT_FOCUS:
			pointer.set_visible(false)
