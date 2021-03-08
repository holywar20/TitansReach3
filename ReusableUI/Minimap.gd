extends PanelContainer

var currentDate
var system : SystemResource
var myPlanets : Array = []

const STAR_SPACER = 40
const PLANET_ORBIT_FACTOR = 20
const ORBIT_SEGMENT_COUNT = 25
const ORBIT_CENTER = Vector2( 0 , 0 )
const ORBIT_LINE_WIDTH = 10

onready var planetIconScene = preload("res://ReusableUI/Minimap/Planet.tscn")

onready var sectorSystemName = $VBox/TopRow/System

onready var date = $VBox/VBox/Date/Data
onready var fuel = $VBox/VBox/Fuel/Data
onready var food = $VBox/VBox/Food/Data
onready var ink = $VBox/VBox/Ink/Data
onready var morale = $VBox/VBox/Ink/Data

onready var map = $VBox/Map
onready var replaceAbles = $VBox/Map/Replacables
onready var starIcon = $VBox/Map/Replacables/Star
onready var planetIconBase = $VBox/Map/PlanetBase

# TODO : Allow for navigation input
func _draw():
	pass
	#for planetData in myPlanets:
	#	if( planetData ):
	#		print( starIcon.get_position() ,  PLANET_ORBIT_FACTOR * planetData.orbit )
	#		replaceAbles.draw_circle( Vector2( 200, 150 ) , PLANET_ORBIT_FACTOR * planetData.orbit , Color( 1, 1, 1 ,1) )

	#update()

func setupScene( newSystem : SystemResource ):
	system = newSystem
	var myStar = system.stars[0]
	myPlanets = myStar.planets

	starIcon.setupScene( myStar )
	sectorSystemName.set_text( myStar.starName )

	for planetData in myStar.planets:
		if( planetData ):
			var planetIconInstance = planetIconScene.instance()
			planetIconInstance.setupScene( planetData )
			planetIconInstance.set_position( planetData.radial * PLANET_ORBIT_FACTOR * planetData.orbit )
			planetIconBase.add_child( planetIconInstance )
			# TODO : Wire up the icons so that 'selection is possible'

	update()

func updateVolitileReadout( fuel , food , ink , morale ):
	pass
