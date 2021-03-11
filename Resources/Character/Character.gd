extends TitansResource
class_name CharacterResource

const BASE_WEIGHT = 3
const BASE_HP = 20
const BASE_MORALE = 8
const BASE_CHARGE = 2
const TRAIT_RESIST_BONUS = 5
const DEFENSE_MULTIPLE = 5
const HP_LEVEL_MULTIPLE = 2


# Cosmetics
var fullname = ["First" , "nickname" , "Last"]
var sex  = null
var height = 2.1
var mass = 95
var race = "Terran" # TODO add ability for crewman to be many races
var homeWorld = "Earth" # TODO Link homeworld to in game worlds which can potentially be discovered.
var age = 100
var bio = "four score and seven years ago. Yeah. I'm abraham Lincoln Bitch."
var texturePath = null
var smallTexturePath = null

var id = null
var cp = 0
var cpSpent = 0

# Status flags
var isDead = false
var isPlayer = false

# Other State
var station = null
var currentStanceKey = null


enum GEAR {
	WEAPON , ARMOR , EQUIP
}

var gear = {
	GEAR.ARMOR : [ false ],
	GEAR.WEAPON : [ false , false ],
	GEAR.EQUIP : [ false , false , false ]
}

# abilityTrees
var defaultTree = null
var primaryTree = null
var secondaryTree = null 
var equipmentAbilities = null

# store off all this users abilities
var actions = []
var stances = []
var instants = []

var temporaryPassives = {}

const TRAITS = {
	"CHA" : "CHA" , "INT" : "INT" , "DEX" : "DEX" ,  "STR" : "STR" , "PER" : "PER"
}
var traits = {
	TRAITS.STR : { "name" : "STR", "fullName": "Strength" 	, "value": 0, "total" : 0 , "equip" : 0 , "talent": 0 ,"mod" : 0 },
	TRAITS.CHA : { "name" : "CHA", "fullName": "Charisma" 	, "value": 0, "total" : 0 , "equip" : 0 , "talent": 0 ,"mod" : 0 },
	TRAITS.PER : { "name" : "PER", "fullName": "Perception"	, "value": 0, "total" : 0 , "equip" : 0 , "talent": 0 ,"mod" : 0 },
	TRAITS.DEX : { "name" : "DEX", "fullName": "Dexerity" 	, "value": 0, "total" : 0 , "equip" : 0 , "talent": 0 ,"mod" : 0 },
	TRAITS.INT : { "name" : "INT", "fullName": "Intelligence", "value": 0, "total" : 0 , "equip" : 0 , "talent": 0 ,"mod" : 0 }
}

# Derived traits
var carryWeight = { "value": 0, "total" : 0 , "mod" : 0 , 'current' : 0 }
var hp = { "value": 18, "total" : 18 , "mod" : 0 , 'current' : 18 }
var morale = { "value": 18, "total" : 18 , "mod" : 0  , 'current': 18}
var charge = { "value" : 5 , "total" : 5 , "mod" : 0 , 'current' : 0}
var defense = { "value" : 0 , "total" : 0 , "mod" : 0 , 'current' : 0 }

var damageReduction = { 
	'KINETIC': 	{ "value" : 0, "total" : 0 , "mod" : 0 },
	'THERMAL': 	{ "value" : 0, "total" : 0 , "mod" : 0 }, 
	'TOXIC': 	{ "value" : 0, "total" : 0 , "mod" : 0 }, 
	'EM':		{ "value" : 0, "total" : 0 , "mod" : 0 }, 
}

const RESISTS = {
	"MOVE" : "MOVE" , "SILENCE" : "SILENCE" , "CHARM" : "CHARM" , "STUN" : "STUN" , "OPPRESS": "OPPRESS" ,"BLEED" : "BLEED" , "MARKED" : "MARKED","SLOW" : "SLOW"
}
var resists = {
	RESISTS.MOVE : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 } ,
	RESISTS.SILENCE : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 },
	RESISTS.CHARM : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 } ,
	RESISTS.STUN :  { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 },
	RESISTS.OPPRESS : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 },
	RESISTS.BLEED : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 },
	RESISTS.MARKED : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 },
	RESISTS.SLOW : { "trait" : 0, "total" : 0 , "mod" : 0 , "talent": 0 , "equip" : 0 }
}

# Overrides
func get_class(): 
	return "CharacterResource"

func is_class( name : String ): 
	return name == "CharacterResource"

func setDefaultAbilityTree( abilityTree : AbilityTreeResource ):
	defaultTree = abilityTree

func setPrimaryAbilityTree(  abilityTree : AbilityTreeResource ):
	primaryTree = abilityTree
	
func setSecondaryAbilityTree(  abilityTree : AbilityTreeResource ):
	secondaryTree = abilityTree

func canEquip( slotType , slot, item ):
	pass
	# Test Carry weight

func equipItem( slotType, slot , item ):
	var oldItem = gear[slotType][slot]
	gear[slotType][slot] = item
	return oldItem

func calculateSelf( newCharacter = false ):

	#_getAbilityKeysFromGear()
	_getAbilityKeysFromTalents()

	#_loadPassiveAbilitiesFromSavedKeys()
	# Load passive abilities

	_calculateTraits()
	_calculateResists()
	_calculateCarryWeight()
	_calculateDerivedStats( newCharacter )

func _getAbilityKeysFromTalents():
	for tree in [ defaultTree , primaryTree , secondaryTree ]:
		for ability in tree.abilityStore:
			if( ability ):
				match ability.abilityType:
					AbilityResource.ABILITY_TYPE.ACTION:
						actions.append( ability )
					AbilityResource.ABILITY_TYPE.STANCE:
						stances.append( ability )
					AbilityResource.ABILITY_TYPE.INSTANT:
						instants.append( ability )
	

func _calculateTraits():
	for key in traits:
		traits[key].total = traits[key].value + traits[key].mod

func _calculateCarryWeight():
	carryWeight.total = BASE_WEIGHT + carryWeight.mod + traits.STR.total
	
	var current = 0
	#for key in gear:
	#	if( gear[key] ):
	#		current = current + gear[key].itemCarryWeight
		
	carryWeight.current = current

func _calculateDerivedStats( newCharacter = false ):
	
	# TODO : Add check for status Effects
	# TODO : Should have some modification for HP based on CP
	hp.total = BASE_HP + hp.mod + ( traits.STR.total * HP_LEVEL_MULTIPLE )
	morale.total = BASE_MORALE + morale.mod + traits.CHA.total
	charge.total = BASE_CHARGE + charge.mod + traits.CHA.total
	defense.total = 0 + defense.mod + traits.PER.total

	if( newCharacter ):
		charge.current = 0
		hp.current = hp.total
		morale.current = morale.total
		defense.current = defense.total


func _calculateResists():
	resists.MOVE.trait = traits.STR.total
	resists.MOVE.total = resists.MOVE.trait + resists.MOVE.mod + resists.MOVE.talent + resists.MOVE.equip
	
	resists.STUN.trait = traits.STR.total
	resists.STUN.total = resists.STUN.trait + resists.STUN.mod + resists.STUN.talent + resists.STUN.equip

	resists.BLEED.trait = traits.STR.total
	resists.BLEED.total = resists.BLEED.trait + resists.BLEED.mod + resists.BLEED.talent + resists.BLEED.equip

	resists.SILENCE.trait = traits.PER.total
	resists.SILENCE.total = resists.SILENCE.trait + resists.SILENCE.mod + resists.SILENCE.talent + resists.SILENCE.equip
	
	resists.MARKED.trait = traits.DEX.total
	resists.MARKED.total = resists.MARKED.trait + resists.MARKED.mod + resists.MARKED.talent + resists.MARKED.equip

	resists.SLOW.trait = traits.DEX.total
	resists.SLOW.total = resists.SLOW.trait + resists.SLOW.mod + resists.SLOW.talent + resists.SLOW.equip

	resists.OPPRESS.trait = traits.INT.total
	resists.OPPRESS.total = resists.OPPRESS.trait + resists.OPPRESS.mod + resists.OPPRESS.talent + resists.OPPRESS.equip

	resists.CHARM.trait = traits.INT.total
	resists.CHARM.total = resists.CHARM.trait + resists.CHARM.mod + resists.CHARM.talent + resists.CHARM.equip

func getNickName():
	return fullname[1]

func getFullName():
	return fullname[0] + ' "' + fullname[1] + '" ' + fullname[2]

func getCPointString():
	if( !isDead ):
		return str(cpSpent) + " / " + str(cp)
	else:
		return "0 / 0"

func getMassString():
	return str(mass) + " Kg"

func getHeightString():
	return str(height) + " cm"

func getWorldString():
	return homeWorld

func getAgeString():
	return str( age ) + " yrs"

func getRaceString():
	return race

func getSexString():
	return sex

func getHPStatBlock():
	return hp

func getHitPointString():
	return str(hp.current) + " / " + str(hp.total)

func getMoraleStatBlock():
	return morale

func getMoraleString():
	return str(morale.current) + " / " + str(morale.total)

func getChargeStatBlock():
	return charge

func getChargeString():
	return str(charge.current) + " / " + str(charge.total)

func getWeightStatBlock():
	return carryWeight

func getWeightString():
	return str( carryWeight.current ) + " / " + str(carryWeight.total )

func getTexturePath( large = false ):
	if( large ):
		return texturePath
	else:
		return smallTexturePath

func getBonus( primaryTrait : String , secondaryTrait : String ):
	return traits[primaryTrait].total + ( traits[secondaryTrait].total / 2 )

func getTraitTotal( trait : String ):
	if( traits.has( trait ) ):
		return traits[trait].total
	elif( trait == TRAITS.NONE ):
		return 0
	else:
		print("Dev Error: requested a trait that doesn't exist:" , trait )
		return null

func getTraitStatBlock( trait ):
	if( traits.has( trait ) ):
		return traits[trait].duplicate()
	else: 
		return null

func getAllTraitStatBlocks():
	return traits.duplicate()

func getResistStatBlock( resist ):
	if( resists.has( resist ) ):
		return resists[resist].duplicate()
	else:
		return null

func getAllResistStatBlocks():
	return resists.duplicate()

func getDmgResistStatBlock( dmgBlock ):
	return damageReduction[dmgBlock].duplicate()

func getFightableStatus():
	var isFightable = true

	if( isDead ):
		isFightable = false

	return isFightable

# Rolls
func rollInit():
	var init = traits.PER.total
	return init

func getCurrentTrait( traitKey : String):
	if( traitKey ):
		return traits[traitKey].total
	else:
		return 0

# Mutates the character on the basis of data
func calculateDamage( result : DamageEffectResource.Result ):

	if( (result.toHitRoll - defense.current) >= 180 ):
		result.success = DamageEffectResource.Result.CRITICAL
		result.dmgRoll = ( result.dmgRoll - ( result.dmgRoll * damageReduction[result.dmgType].total ) ) * 2

		hp.current = hp.current - result.dmgRoll
		if( hp.current <= 0 ):
			isDead = true
			hp.current = 0	
	
	elif( (result.toHitRoll - defense.current) >= 100 ):
		result.success = DamageEffectResource.Result.HIT
		# Apply basic damage reduction
		result.dmgRoll = result.dmgRoll - ( result.dmgRoll * damageReduction[result.dmgType].total )

		hp.current = hp.current - result.dmgRoll
		if( hp.current <= 0 ):
			isDead = true
			hp.current = 0
	else:
		result.success = DamageEffectResource.Result.MISS

	return result

func calculateHealing( result : HealEffectResource.Result ):
	if( result.toHitRoll >= 100 ):
		result.success = HealEffectResource.Result.HEALING
		result.healRoll = result.healRoll # Check for status effects that improve or weaken healing effect

		hp.current = hp.current - result.healRoll
		if( hp.current >= hp.total ):
			hp.current = hp.total	

	return result

func calculateMovement( result : MoveEffectResource.Result ):
	if( result.toHitRoll >= 100 ):
		result.success = MoveEffectResource.Result.MOVE
	
	return result

func calculateStatusEffect( result ):
	return result

func calculatePassive( result ):
	return result
