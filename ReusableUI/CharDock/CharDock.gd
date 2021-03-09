extends Panel

var station : StationResource
var character : CharacterResource

onready var label : Label = $Label

func setupScene( newStation : StationResource ):
	station = newStation

	label.set_text( station.shortName )


