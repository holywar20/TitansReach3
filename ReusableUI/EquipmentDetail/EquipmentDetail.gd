extends Panel

var myItem : ItemResource

onready var title : Label = $TitleRow/Label
onready var icon : TextureRect = $HBox/HBox/Icon
onready var desc : Label = $HBox/Label

onready var data = {
	"TValue" : $HBox/HBox/Data/ValueRow/TValue,
	"Value" : $HBox/HBox/Data/ValueRow/Value,
	"Volume" : $HBox/HBox/Data/VolumeRow/Volume,
	"TVolume" :$HBox/HBox/Data/VolumeRow/TVolume,
	"Mass" : $HBox/HBox/Data/WeightRow/Mass,
	"TMass" : $HBox/HBox/Data/WeightRow/TMass
}

func updateUI( newItem ):
	if( newItem == null ):
		hide()
	else:
		show()
		myItem = newItem

		title.set_text( myItem.itemDisplayName  + "  ( " + str(myItem.itemAmount) + " ) " )
		desc.set_text( myItem.itemDescription )
		icon.set_texture( load(myItem.itemTexturePath ) )
		
		data.TValue.set_text( myItem.getAllItemValueDisplay() )
		data.Value.set_text( myItem.getItemValueDisplay() )
		data.TVolume.set_text( myItem.getAllVolumeDisplay() )
		data.Volume.set_text( myItem.getVolumeDisplay() )
		data.Mass.set_text( myItem.getMassDisplay() )
		data.TMass.set_text( myItem.getAllMassDisplay() )

