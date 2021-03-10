extends ProgressBar

onready var valueDisplay : Label = $Label

enum BAR_TYPE {
	HEALTH , CHARGE , MORALE , MASS, VOLUME
}

var barData = {
	BAR_TYPE.HEALTH : {
		"fillColor": Color( 1 , 0 , 0 , 1 ),
		"barColor" : Color( .35, 0 , 0 , 1 )
	} ,
	BAR_TYPE.CHARGE : {
		"fillColor": Color( 0 , 1 , 0 , 1 ),
		"barColor" : Color(0 , .35, 0 , 1 ) 
	} ,
	BAR_TYPE.MORALE : {
		"fillColor": Color( 1 ,  1 ,  0 , 1 ),
		"barColor" : Color(.35 , .35 , 0 , 1 )
	} ,
	BAR_TYPE.MASS : {
		"fillColor" : Color( 1, 0, 1, 1 ),
		"barColor" : Color( .35, 0, .35, 1 )
	},
	BAR_TYPE.VOLUME: {
		"fillColor" : Color( 0, 1, 1, 1 ),
		"barColor" : Color( 0, .35, .35, 1 )
	}
}

export(BAR_TYPE) var barType = BAR_TYPE.HEALTH

func _ready():
	set_self_modulate( barData[barType].fillColor )

func setBarValues( total : int , current : int ):
	set_max( total )
	set_value( current )

	valueDisplay.set_text( str(current) + "/" + str(total) )

