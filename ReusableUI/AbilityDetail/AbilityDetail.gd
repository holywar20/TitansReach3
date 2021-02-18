extends PanelContainer

var noArea = preload("res://AssettsImage/Interface/black-square.png")
var goArea = preload("res://AssettsImage/Interface/square.png")
var goAttack = preload("res://AssettsImage/Interface/SmallCrossHair.png")

var currentAbility : AbilityResource

onready var abilityIcon : TextureRect = $VBox/TitleRow/AbilityIcon
onready var title : Label = $VBox/TitleRow/Label
onready var detailText : RichTextLabel = $VBox/TextRow/RTLabel

onready var validFrom : Array = [
	$VBox/ValidRow/PlayerFront,
	$VBox/ValidRow/PlayerMid,
	$VBox/ValidRow/PlayerBack
]
onready var validTargets : Array = [
	$VBox/ValidRow/EnemyFront,
	$VBox/ValidRow/EnemyMid,
	$VBox/ValidRow/EnemyBack
]
onready var areaGrid : Array = [
	[
		get_node("VBox/TextRow/VBox/AreaGrid/0_0"), 
		get_node("VBox/TextRow/VBox/AreaGrid/0_1"),  
		get_node("VBox/TextRow/VBox/AreaGrid/0_2")
	] , [
		get_node("VBox/TextRow/VBox/AreaGrid/1_0"), 
		get_node("VBox/TextRow/VBox/AreaGrid/1_1"),  
		get_node("VBox/TextRow/VBox/AreaGrid/1_2") 
	] , [
		get_node("VBox/TextRow/VBox/AreaGrid/2_0"), 
		get_node("VBox/TextRow/VBox/AreaGrid/2_1"),  
		get_node("VBox/TextRow/VBox/AreaGrid/2_2") 
	]
]

func setupScene( ability : AbilityResource ):
	if( ability ):
		show()
		currentAbility = ability

		# Set simple data
		abilityIcon.set_texture(load(currentAbility.iconPath))
		title.set_text(currentAbility.fullName)
		detailText.set_bbcode( currentAbility.description )

		# Set the ability target rows
		for x in range( 0, validTargets.size() ):
			if x in currentAbility.validTargets:
				validTargets[x].set_texture(goAttack)
			else:
				validTargets[x].set_texture(noArea)

		for x in range(0, validFrom.size() ):
			if x in currentAbility.validFrom:
				validFrom[x].set_texture(goAttack)
			else:
				validFrom[x].set_texture(noArea)

		# Set the target area now
		var myTargetArea = currentAbility.getTargetAreaAsMatrix()
		for x in range( 0, areaGrid.size() ):
			for y in range( 0, areaGrid[x].size() ):
				if( myTargetArea[x][y] ):
					areaGrid[x][y].set_texture(goArea)
				else:
					areaGrid[x][y].set_texture(noArea)

		
	else:
		hide()

