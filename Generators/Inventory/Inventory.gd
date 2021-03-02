extends Node

var allItems = {}

func getItem( itemKey : String ):
	if( allItems.has(itemKey) ):
		return allItems[itemKey]
	else:
		return null

func getFilteredListByItemClass() -> Array:
	return []

func getEquipableItems() -> Array :
	var equipable = []
	
	for key in allItems:
		if allItems[key].itemIsCrewEquipable:
			equipable.append( allItems[key] )
	
	return equipable
	
func getNonequipableItems() -> Array :
	var nonEquipable = []
	
	for key in allItems:
		if !allItems[key].itemIsCrewEquipable:
			nonEquipable.append( allItems[key] )
	
	return nonEquipable

func _ready():
	allItems['MAENESHIUM'] = CommodityResource.new( "MAENESHIUM" , CommodityResource.PATH.BASIC, 100)
	allItems['FOODSTUFFS'] = CommodityResource.new( "FOODSTUFFS" , CommodityResource.PATH.BASIC, 100)
	allItems['WATER'] = CommodityResource.new( "WATER" , CommodityResource.PATH.BASIC, 100)
	# Generate Random commodoties
	# Generate Ship Mods
	# Generate Frames
	# Generate Weapons
