extends Node

var health : int = 5
var arrows : int = 5
var player : CharacterBody2D

func _ready() -> void:
	GlobalSignals.shoot_arrow.connect(shoot)
	GlobalSignals.collected_arrow.connect(pick_up_arrow)
	GlobalSignals.took_damage.connect(get_hit)
	get_tree().create_timer(0.1).timeout.connect(find_player)

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
	if health == 0:
		#TO DO:
		print("YOU DIED")
