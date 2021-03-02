extends Panel

onready var itemTree : Tree = $Tripane/TabContainer/Commodities/Tree
onready var armsRoom : VBoxContainer = $Tripane/TabContainer/Commodities/Equipment

const HEADERS = [
	"" , "Mass" , "Volume" ,  "Value" ,  "Quantity"
]
enum COL {
	NAME , MASS, VOLUME, VALUE, QUANTITY
}

var commodities = {}
var arms = {}

var root : TreeItem
var volitiles : TreeItem
var minerals : TreeItem 

func resetInventory():
	root = itemTree.create_item()
	root.disable_folding = true
	
	for x in range( 0, HEADERS.size () ):
		root.set_text( x  , HEADERS[x])
	
	volitiles = itemTree.create_item( root )
	volitiles.set_text( COL.NAME ,  "Volitiles" )

	minerals = itemTree.create_item( root )
	minerals.set_text( COL.NAME ,  "Minerals" )

# Arrays of Commodity items, and mixed equipment, frames and weapons in arms
func setupScene( newCommodities : Array , newArms : Array):
	resetInventory()
	
	commodities = newCommodities
	arms = newArms

	for commodity in commodities:
		_createTreeItem( commodity )
		
	

func _createTreeItem( item : ItemResource ):
	var target : TreeItem
		
	match item.itemType:
		ItemResource.ITEM_TYPE.VOLITILE:
			target = volitiles
		ItemResource.ITEM_TYPE.MINERAL:
			target = minerals

	var newItem = itemTree.create_item( target )
	newItem.set_text( COL.NAME , item.itemDisplayNameShort )
	newItem.set_text( COL.MASS , item.getAllMassDisplay() )
	newItem.set_text( COL.VOLUME , item.getAllVolumeDisplay() )
	newItem.set_text( COL.VALUE , item.getItemValueDisplay() )
	newItem.set_text( COL.QUANTITY, str(item.itemAmount) )
