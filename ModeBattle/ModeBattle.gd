extends Node2D


onready var groundMap : TileMap = $Ground
onready var crewGenerator : Node = $CrewGenerator
onready var playerBase : YSort = $Players
onready var enemyBase : YSort = $Enemy

onready var turnOrder : PanelContainer = $CanvasLayer/Turnorder

var battlerScene = preload("res://ModeBattle/Battler.tscn")

const TILE_SIZE : Vector2 = Vector2(128, 64)
const TILE_OFFSET : Vector2 = Vector2(32, 64)
const PLAYER_TILE_MAP = [
	[Vector2(8,7), Vector2(8,4), Vector2(8,1) , Vector2(8,-2) , Vector2(8,-5)],
	[Vector2(11,7), Vector2(11,4), Vector2(11,1) , Vector2(11,-2) , Vector2(11,-5)],
	[Vector2(15,7), Vector2(14,2), Vector2(14,0) , Vector2(14,-2) , Vector2(14,-5)],
]

const ENEMY_TILE_MAP = [
	[Vector2(23,-5), Vector2(23,-2), Vector2(23,1) , Vector2(23,4) , Vector2(23,7)],
	[Vector2(20,-5), Vector2(20,-2), Vector2(20,1) , Vector2(20,4) , Vector2(20,7)],
	[Vector2(17,-5), Vector2(17,-2), Vector2(17,1) , Vector2(17,4) , Vector2(17,7)]
]

# starting from back-left to back-right, ending on front-left to front-right.
var playerTiles : FormationResource
var enemyTiles : FormationResource

var crew : Array = []
var enemy : Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	setupScene()

func setupScene( _crew : Array = []):
	crew = crewGenerator.generateManyCrew(30 , 6)
	playerTiles = FormationResource.new( crew )

	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if playerTiles.positions[x][y]:
				var battler = battlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y])

	enemy = crewGenerator.generateManyCrew(30, 6)
	enemyTiles = FormationResource.new( enemy )

	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if enemyTiles.positions[x][y]:
				var battler = battlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y])



