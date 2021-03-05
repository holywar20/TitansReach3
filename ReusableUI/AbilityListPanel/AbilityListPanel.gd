extends Panel

var abilityIconScene = preload("res://ReusableUI/AbilityIcon/AbilityIcon.tscn")

var abilityTree

onready var abilityContainer : GridContainer = $VBox/GridContainer
onready var title : Label = $VBox/ClassName

signal abilityChanged( ability )
signal abilityExit( ability )

func setupScene( newTree ):
	updateUI( newTree )

func updateUI( newTree ):
	abilityTree = newTree

	title.set_text( abilityTree.treeName )

	for child in abilityContainer.get_children():
		child.queue_free()

	for thisAbility in abilityTree.abilityStore:
		var newIcon = abilityIconScene.instance()
		
		abilityContainer.add_child( newIcon )
		newIcon.setupScene( thisAbility )
		newIcon.allowFocus()

		newIcon.get_node("TextureButton").connect("focus_entered" , self , "on_AbilityIcon_focus_entered" , [newIcon.ability])
		newIcon.get_node("TextureButton").connect("focus_exited" , self , "on_AbilityIcon_focus_exited" , [newIcon.ability])

func on_AbilityIcon_focus_entered( ability : AbilityResource ):
	# Bit of a hack, but we want focus entered to occur after exit to ensure
	# That the exit signal fires first.
	yield( get_tree().create_timer( 0.01 ), "timeout")
	emit_signal("abilityChanged" , ability )

func on_AbilityIcon_focus_exited( ability : AbilityResource ):
	emit_signal("abilityExit" , ability )
