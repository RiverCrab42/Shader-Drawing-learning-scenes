extends Node

var health : int = 3
var arrows : int = 524252
var player : CharacterBody2D

var instantiated_objects : Array[Node]

func my_instantiate(object) -> Node:
	if object:
		var instance = object.instantiate()
	
		instantiated_objects.append(instance)
		return instance
	else:
		return Node2D.new()

func reset() -> void:
	for obj in instantiated_objects:
		if obj:
			obj.queue_free()
	instantiated_objects.clear()
	health = 5
	arrows = 5
	GlobalSignals.shoot_arrow.connect(shoot)
	GlobalSignals.collected_arrow.connect(pick_up_arrow)
	GlobalSignals.took_damage.connect(get_hit)
	find_player()

func _ready() -> void:
	GlobalSignals.shoot_arrow.connect(shoot)
	GlobalSignals.collected_arrow.connect(pick_up_arrow)
	GlobalSignals.took_damage.connect(get_hit)
	find_player()

func find_player() -> void:
	var root = get_tree().get_current_scene()
	find_player_recursive(root)
	
func find_player_recursive(obj : Node) -> void:
	if obj is Player:
		player = obj
	for child in obj.get_children():
		find_player_recursive(child)
	
func shoot() -> void:
	arrows -= 1

func pick_up_arrow() -> void:
	arrows += 1

func get_hit() -> void:
	health -= 1
	print("Damaged")
	if health <= 0:
		GlobalSignals.game_over.emit()
		GameManager.player.game_over()
		print("game over")
