extends Node

const MAKE_ENEMY = false
const MAKE_PLAYER = true
	
# TODO - Write script that populates this data from a database
const MALE_PORTRAITS_FOLDER = "res://AssettsImage/Faces/BorrowedMen/"
const MALE_PORTRAITS = [
	"man-1", "man-2", "man-3" , "man-4" , "man-5" , "man-6"
]

const FEMALE_PORTRAITS_FOLDER = "res://AssettsImage/Faces/BorrowedWomen/"
const FEMALE_PORTRAITS = [
	"woman-1" , "woman-2" , "woman-3" ,  "woman-4" , "woman-5" 
]

const CREW_NAME_LIST_PATH = "res://Generators/Data/CrewList.json"

const SEX = ["M", "F"]

const AGE_RANGE = [ 24 , 55 ]
const MALE_MASS_RANGE = [ 55 , 100 ]
const FEMALE_MASS_RANGE = [ 45 , 80 ]
const MALE_HEIGHT_RANGE = [ 150 , 210 ] # In centimeters
const FEMALE_HEIGHT_RANGE = [ 140 , 200 ]

const HOMEWORLDS = [ "Earth" , "Nova" , "Calderas" , "Solaris"]
const MAJOR_RACE = [ "Human" ]
const HUMAN_SECTS = ["Meridian" , "Novan" , "Terran" ]

var dummyCrewman

func _ready():
	pass

func createDummyCrewman():
	dummyCrewman = generateNewCrew( 0 )

func getDummyCrewman():
	return dummyCrewman

func generateManyCrew( cp : int  , numOfCrew : int  ):
	var crewArray = []

	for x in range(0 , numOfCrew ):
		crewArray.append( generateNewCrew( cp ) )

	return crewArray

func generateNewCrew( cp = 30 ):
	var crewman = CharacterResource.new()

	crewman = _rollTraits( crewman , cp )
	crewman = _rollCosmetics( crewman )
	# crewman = _rollTalents( crewman )
	
	crewman.calculateSelf( true )

	return crewman

func _rollTraits( myCrewman : CharacterResource , cp = 30):
	var statTotal = 0

	myCrewman.cp = cp

	while statTotal <= myCrewman.cp:
		var rand = randi() % myCrewman.traits.size()
		var keys = myCrewman.traits.keys()
		var stat = keys[rand]
		
		myCrewman.traits[stat].value = myCrewman.traits[stat].value + 1
		statTotal += myCrewman.traits[stat].value
	
	# Crewman can potentially roll higher than their aviailable CP randomly. If that is true, that sets the value here.
	myCrewman.cpSpent = statTotal
	if( statTotal >= statTotal ):
		myCrewman.cp = statTotal

	return myCrewman


func _rollCosmetics( myCrewman : CharacterResource  ):
	var sex = SEX[ randi() % SEX.size() ]
	var texture = ""
	var fname = ""
	var height = 0
	var mass = 0

	var nameFile = File.new()
	nameFile.open( CREW_NAME_LIST_PATH , File.READ)
	var nameTable = parse_json( nameFile.get_as_text() )
	nameFile.close()

	var lname = nameTable.lastNames[ randi() % nameTable.lastNames.size() ]
	var mname = nameTable.codeNames[ randi() % nameTable.codeNames.size() ]

	if( sex == "M"):
		fname = nameTable.maleFirstNames[ randi() % nameTable.maleFirstNames.size() ]
		texture = MALE_PORTRAITS_FOLDER + MALE_PORTRAITS[ randi() % MALE_PORTRAITS.size() ]
		height = myCrewman.randDiffValues( MALE_HEIGHT_RANGE[0] , MALE_HEIGHT_RANGE[1] )
		mass = myCrewman.randDiffValues( MALE_MASS_RANGE[0] , MALE_MASS_RANGE[1] )
		
	if( sex == "F"):
		fname = nameTable.femaleFirstNames[ randi() % nameTable.femaleFirstNames.size() ]
		texture = FEMALE_PORTRAITS_FOLDER + FEMALE_PORTRAITS[ randi() % FEMALE_PORTRAITS.size() ]
		height = myCrewman.randDiffValues( FEMALE_HEIGHT_RANGE[0] , FEMALE_HEIGHT_RANGE[1] )
		mass = myCrewman.randDiffValues( FEMALE_MASS_RANGE[0] , FEMALE_MASS_RANGE[1] )
	
	myCrewman.texturePath = texture + ".jpg"
	myCrewman.smallTexturePath = texture + "-small.jpg"
	myCrewman.sex = sex
	myCrewman.height = height
	myCrewman.mass = mass
	
	myCrewman.fullname = [ fname, mname, lname ]

	myCrewman.age = myCrewman.randDiffValues( AGE_RANGE[0] , AGE_RANGE[1] )
	myCrewman.bio = "Not Yet Implimented. Also, I'm a fucking badass murder-hobo hero."

	return myCrewman
	
