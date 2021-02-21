extends Node2D
class_name Battler

var currentCharacter : CharacterResource
onready var characterSprite : Sprite = $Sprite
onready var dataBlock : Control = $Data

const OUTLINE_SHADER = preload("res://Shaders/OutlineShader.shader")

enum SELECTION {
	NONE, TURN_TARGET, ASSIST_TARGET, ATTACK_TARGET
}

var highlightShaderParams = {
	HIGHLIGHT.SELECTED_ALLY : {
		"width" : 5 , "outline_color" : Color(0,0,200,255)
	} ,
	HIGHLIGHT.SELECTED_ENEMY : {
		"width" : 5 , "outline_color" : Color(200,0,0,255)
	},
	HIGHLIGHT.NEAR_ALLY : {
		"width" : 3 , "outline_color" : Color(0,0,100,255)
	},
	HIGHLIGHT.NEAR_ENEMY : {
		"width" : 3 , "outline_color" : Color(100,0,0,255)
	}
}

var turnShaderParams = {
	STATE.NOT_TURN : {
		"width" : 1 , "outline_color" : Color(0,0,0,255)
	},
	STATE.TURN : {
		"width" : 1 , "outline_color" : Color(0,200,0,255)
	}
}

enum HIGHLIGHT {
	SELECTED_ALLY , SELECTED_ENEMY, NEAR_ALLY , NEAR_ENEMY, NONE
}

enum STATE {
	TURN, NOT_TURN
}

var currentFormationLocation = Vector2(0,0)
var highlightState = HIGHLIGHT.NONE
var turnState = STATE.NOT_TURN

# Overrides
func get_class(): 
	return "Battler"

func is_class( name : String ): 
	return name == "Battler"

func setupScene( newCharacter : CharacterResource , newLocation : Vector2 ):
	currentCharacter = newCharacter
	currentFormationLocation = newLocation
	
	# Set up outline shader. Shaders must be instanced in code.
	var mat = ShaderMaterial.new()
	mat.set_shader(OUTLINE_SHADER)
	mat.set_shader_param("width" , turnShaderParams[STATE.NOT_TURN].width )
	mat.set_shader_param("outline_color" , turnShaderParams[STATE.NOT_TURN].outline_color )
	characterSprite.set_material(mat)

	_updateCharacterData()

func _updateShader( params : Dictionary ):
	var mat = characterSprite.get_material()
	mat.set_shader_param("width" , params.width )
	mat.set_shader_param("outline_color" , params.outline_color )

func _updateCharacterData():
	dataBlock.updateData( currentCharacter )

func setHighlightState( state : int ):
	highlightState = state
	
	var useTurnShaders = false

	match highlightState:
		HIGHLIGHT.NONE:
			pass
			useTurnShaders = true
		HIGHLIGHT.SELECTED_ALLY:
			pass
		HIGHLIGHT.SELECTED_ENEMY:
			pass
		HIGHLIGHT.NEAR_ALLY:
			pass
		HIGHLIGHT.NEAR_ENEMY:
			pass

	if( useTurnShaders ):
		_updateShader( turnShaderParams[turnState] )
	else:
		_updateShader( highlightShaderParams[highlightState] )

func setTurnState( state : int ):
	turnState = state
	
	match turnState:
		STATE.TURN:
			pass
		STATE.NOT_TURN:
			pass

	# Set highlight state to the same highlightState to change any shaders or effects that we might care about.
	setHighlightState( highlightState )
