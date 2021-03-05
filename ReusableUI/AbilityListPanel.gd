extends Panel

var abilityIconScene = preload("res://ReusableUI/AbilityIcon/AbilityIcon.tscn")

var abilityTree

onready var abilityContainer : GridContainer = $VBox/GridContainer

signal abilityChanged( ability )

func setupScene( newTree ):
	updateUI( newTree )

func updateUI( newTree ):
	abilityTree = newTree

	for child in abilityContainer.get_children():
		child.queue_free()

	for ability in abilityTree.abilityStore:
		var newIcon = abilityIconScene.instance()
		newIcon.setupScene( ability )
		newIcon.allowFocus()

		newIcon.connect("focus_entered" , self , "on_AbilityIcon_focus_entered" [newIcon.ability])

func on_AbilityIcon_focus_entered( ability : AbilityResource ):
	emit_signal("abilityChanged" , ability )
