extends Panel

onready var itemTree : Tree = $Tripane/Commodities/Tree

# Sub UI scenes
onready var abilityDetail : Panel = $Tripane/ItemDetails/AbilityDetail
onready var equipmentDetail : Panel = $Tripane/ItemDetails/EquipmentDetail

# Basic Data
onready var massBar = $Tripane/Commodities/HBox/Mass/Bar
onready var volumeBar = $Tripane/Commodities/HBox/Volume/Bar
onready var valueBox = $Tripane/Commodities/HBox/Value/Data

var inventory = null

const HEADERS = [
	"" , "" , "Mass" , "Volume" ,  "Value" ,  "Quantity"
]
enum COL {
	ICON, NAME , MASS, VOLUME, VALUE, QUANTITY
}

var commodities = {}
var arms = {}
var root : TreeItem

var treeItems = {
	ItemResource.ITEM_CATEGORY.VOLITILE: null,
	ItemResource.ITEM_CATEGORY.MINERAL: null,
	ItemResource.ITEM_CATEGORY.ARMOR: null,
	ItemResource.ITEM_CATEGORY.WEAPON: null,
	ItemResource.ITEM_CATEGORY.EQUIPMENT: null
}

func resetInventory():
	itemTree.clear()
	
	root = itemTree.create_item()
	root.disable_folding = true
	
	for x in range( 0, HEADERS.size () ):
		root.set_text( x  , HEADERS[x])
	
	var volitiles = itemTree.create_item( root )
	volitiles.set_text( COL.NAME ,  "Volitiles" )
	treeItems[ItemResource.ITEM_CATEGORY.VOLITILE] = volitiles

	var minerals = itemTree.create_item( root )
	minerals.set_text( COL.NAME ,  "Minerals" )
	treeItems[ItemResource.ITEM_CATEGORY.MINERAL] = minerals

	var armor = itemTree.create_item( root )
	armor.set_text( COL.NAME , "Frames" )
	treeItems[ItemResource.ITEM_CATEGORY.ARMOR] = armor

	var weapon = itemTree.create_item( root )
	weapon.set_text( COL.NAME , "Weapon" )
	treeItems[ItemResource.ITEM_CATEGORY.WEAPON] = weapon

	var equipment = itemTree.create_item( root )
	equipment.set_text( COL.NAME , "Equipment" )
	treeItems[ItemResource.ITEM_CATEGORY.EQUIPMENT] = equipment

# Arrays of Commodity items, and mixed equipment, frames and weapons in arms
func setupScene( newInventory : Node ):
	resetInventory()
	inventory = newInventory

	itemTree.grab_focus()
	
	for itemKey in inventory.allItems:
		_createTreeItem( inventory.allItems[itemKey] )
	
func _createTreeItem( item : ItemResource ):
	var target : TreeItem = treeItems[item.itemCategory]

	var newItem = itemTree.create_item( target )
	# TODO set the icon
	newItem.set_icon( COL.ICON , load(item.itemTexturePath) )
	newItem.set_icon_max_width( COL.ICON , 32 )
	newItem.set_text( COL.NAME , item.itemDisplayNameShort )
	newItem.set_text( COL.MASS , item.getAllMassDisplay() )
	newItem.set_text( COL.VOLUME , item.getAllVolumeDisplay() )
	newItem.set_text( COL.VALUE , item.getItemValueDisplay() )
	newItem.set_text( COL.QUANTITY, str(item.itemAmount) )
	newItem.set_metadata( COL.ICON , item.itemKey )

func populateMetadata( inventory ):
	massBar.setBarValues(  inventory.massCapacity , inventory.getTotalMass() )
	volumeBar.setBarValues( inventory.volumeCapacity , inventory.getTotalVolume() )
	valueBox.set_text( inventory.getTotalValueAsString() ) 

func _on_Tree_item_selected():
	var data = itemTree.get_selected()
	if( data ):
		var myItem = inventory.getItem( data.get_metadata( COL.ICON ) )
		equipmentDetail.updateUI( myItem )
	else:
		equipmentDetail.updateUI( null )

