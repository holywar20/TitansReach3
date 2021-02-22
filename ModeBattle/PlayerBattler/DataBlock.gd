extends Control

onready var nameLabel : Label = $Name

onready var healthBar : ProgressBar = $HealthBar
onready var healthAmount : Label = $HealthBar/HealthAmount
const HEALTH_BAR_POSITION = {
	"PLAYER" : Vector2(-115 , -120),
	"ENEMY"  : Vector2(15 , -120)
}

onready var chargeBar : ProgressBar = $ChargeBar
onready var chargeAmount : Label = $ChargeBar/ChargeAmount
const CHARGE_BAR_POSITION = {
	"PLAYER" : Vector2(-100, -100),
	"ENEMY"  : Vector2(0, -100)
}

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

	if( character.isPlayer ):
		healthBar.set_position( HEALTH_BAR_POSITION.PLAYER )
		chargeBar.set_position( CHARGE_BAR_POSITION.PLAYER )
	else:
		healthBar.set_position( HEALTH_BAR_POSITION.ENEMY )
		chargeBar.set_position( CHARGE_BAR_POSITION.ENEMY )
