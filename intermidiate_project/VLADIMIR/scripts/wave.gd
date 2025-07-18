class_name Wave
extends Node2D

var start : bool = false
var die  : int = 0
var end  : bool = false

func _process(delta: float) -> void:
	if 0 == get_child_count():
		end = true
	
