extends Control

onready var nameLabel : Label = $Name

onready var healthBar : ProgressBar = $HealthBar
onready var healthAmount : Label = $HealthBar/HealthAmount

onready var chargeBar : ProgressBar = $ChargeBar
onready var chargeAmount : Label = $ChargeBar/ChargeAmount

func updateData( character : CharacterResource ):
	nameLabel.set_text( character.getNickName() )

	healthAmount.set_text( character.getHitPointString() )
	chargeAmount.set_text( character.getChargeString() )

	var hpBlock : Dictionary = character.getHPStatBlock()
	healthBar.max_value = hpBlock.total
	healthBar.value = hpBlock.current

	var chargeBlock : Dictionary = character.getChargeStatBlock()
	chargeBar.max_value = chargeBlock.total
	chargeBar.value = chargeBlock.current
