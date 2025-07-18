class_name TimerApple
extends Node2D

@onready var spawnPoints: Node = $"../SpawnPointsAppls"
var spawnPoints_pos = []
const APPLE = preload("res://Danil/scenes/collectables/apple.tscn")
var level_viewport : Vector2
var timer : float = 0
var time: float = 1.0

func append_spawnPoints_pos(pos: Vector2) -> void:
	spawnPoints_pos.append(pos)

func _ready() -> void:
	level_viewport = get_viewport_rect().size
	for sp in spawnPoints.get_children():
		spawnPoints_pos.append(sp.global_position)
	
func _process(delta: float) -> void:
	timer += delta
	if timer > time:
		timer = 0.0
		var apple_obj = GameManager.my_instantiate(APPLE)
		add_child(apple_obj)
		time = randi()%5 + 1
		var rand = randi()%len(spawnPoints_pos)
		apple_obj.global_position = Vector2(spawnPoints_pos[rand][0], spawnPoints_pos[rand][1])
		spawnPoints_pos.pop_at(rand)
