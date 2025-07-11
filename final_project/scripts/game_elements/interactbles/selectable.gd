class_name Selectable
extends Node3D

var selected : bool = false

func select(state : bool) -> void:
	selected = state
	print(name, " ", state)
