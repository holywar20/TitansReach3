extends PanelContainer

var currentDate
var system : SystemResource
var myPlanets : Array = []

const STAR_SPACER = 40
const PLANET_ORBIT_FACTOR = 20
const ORBIT_SEGMENT_COUNT = 25
const ORBIT_CENTER = Vector2( 0 , 0 )
const ORBIT_COLOR = Color( 1 ,1 ,1 , 1 )
const ORBIT_LINE_WIDTH = 5

onready var planetIconScene = preload("res://ReusableUI/Minimap/Planet.tscn")

onready var sectorSystemName = $VBox/TopRow/System

onready var date = $VBox/VBox/Date/Data
onready var fuel = $VBox/VBox/FRow/Fuel
onready var food = $VBox/VBox/FRow/FoodAmount
onready var ink = $VBox/VBox/SRow/Ink
onready var morale = $VBox/VBox/SRow/Morale

onready var map = $VBox/Map
onready var replaceAbles = $VBox/Map/Replacables
onready var starIcon = $VBox/Map/Replacables/Star
onready var planetIconBase = $VBox/Map/PlanetBase

# TODO : Allow for navigation input
func _draw():
	for planetData in myPlanets:
		if( planetData ):
			pass
			#drawCircle( planetData.orbit , starIcon )

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

	starIcon.update()

func updateVolitileReadout( _fuel , _food , _ink , _morale ):
	pass

func drawCircle( radius, drawNode ):
	var points_arc = PoolVector2Array()
	
	for segment in range( ORBIT_SEGMENT_COUNT+1):
		var angle_point = int( ( segment * 360 ) / ORBIT_SEGMENT_COUNT - 90 )
		var point = ORBIT_CENTER + Vector2(cos(deg2rad(angle_point)), sin(deg2rad(angle_point))) * radius
		points_arc.push_back(point)
	
	for index_point in range( ORBIT_SEGMENT_COUNT ):
		drawNode.draw_line( points_arc[index_point], points_arc[index_point + 1], ORBIT_COLOR , ORBIT_LINE_WIDTH )
