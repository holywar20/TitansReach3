extends Node2D


onready var groundMap : TileMap = $Ground
onready var crewGenerator : Node = $CrewGenerator
onready var playerBase : YSort = $Players
onready var enemyBase : YSort = $Enemy

onready var turnOrder : PanelContainer = $CanvasLayer/Turnorder

var playerBattlerScene = preload("res://ModeBattle/PlayerBattler/PlayerBattler.tscn")
var enemyBattlerScene = preload("res://ModeBattle/EnemyBattler/EnemyBattler.tscn")


const TILE_SIZE : Vector2 = Vector2(128, 64)
const TILE_OFFSET : Vector2 = Vector2(32, 64)
const PLAYER_TILE_MAP = [
	[Vector2(10,9), Vector2(13,9), Vector2(16,9) , Vector2(19,9) , Vector2(22,9)],
	[Vector2(10,6), Vector2(13,6), Vector2(16,6) , Vector2(19,6) , Vector2(22,6)],
	[Vector2(10,3), Vector2(13,3), Vector2(16,3) , Vector2(19,3) , Vector2(22,3)],
]
const ENEMY_TILE_MAP = [
	[Vector2(22,-6), Vector2(19,-6), Vector2(16,-6) , Vector2(13,-6) , Vector2(10,-6)],
	[Vector2(22,-3), Vector2(19,-3), Vector2(16,-3) , Vector2(13,-3) , Vector2(10,-3)],
	[Vector2(22,0), Vector2(19,0), Vector2(16,0) , Vector2(13,0) , Vector2(10,0)]
]

var playerTiles : FormationResource
var enemyTiles : FormationResource

var crew : Array = []
var enemy : Array = []

# State variables
var currentBattler : Node2D

func _ready():
	setupScene()

func setupScene( _crew : Array = []):
	crew = crewGenerator.generateManyCrew(30 , 6)
	playerTiles = FormationResource.new( crew )

	for x in range(0, playerTiles.positions.size() ):
		for y in range( 0, playerTiles.positions[x].size() ):
			if playerTiles.positions[x][y]:
				var battler = playerBattlerScene.instance()
				battler.position = groundMap.map_to_world( PLAYER_TILE_MAP[x][y] ) + TILE_OFFSET
				playerBase.add_child( battler )
				battler.setupScene(playerTiles.positions[x][y])

	enemy = crewGenerator.generateManyCrew(30, 6)
	enemyTiles = FormationResource.new( enemy )

	for x in range(0, enemyTiles.positions.size() ):
		for y in range( 0, enemyTiles.positions[x].size() ):
			if enemyTiles.positions[x][y]:
				var battler = enemyBattlerScene.instance()
				battler.position = groundMap.map_to_world( ENEMY_TILE_MAP[x][y] ) + Vector2(32, TILE_SIZE.y)
				enemyBase.add_child( battler )
				battler.setupScene(enemyTiles.positions[x][y])

	turnOrder.rollAllTurns(crew, enemy)
	_runBattleLoop()


func _runBattleLoop():
	var crewman : CharacterResource = turnOrder.nextTurn()

	if( crewman.isPlayer ):
		print("player!")
	else:
		print("not Player!")


func _resolveTargeting():
	pass

func _resolveAbility():
	pass

func _testBattleEnd():
	pass
