extends Node

var health : int = 5
var arrows : int = 5

func _ready() -> void:
	GlobalSignals.shoot_arrow.connect(shoot)
	GlobalSignals.collected_arrow.connect(pick_up_arrow)
	GlobalSignals.took_damage.connect(get_hit)
	
func shoot() -> void:
	arrows -= 1

func pick_up_arrow() -> void:
	arrows += 1

func get_hit() -> void:
	health -= 1
	if health == 0:
		#TO DO:
		print("YOU DIED")
