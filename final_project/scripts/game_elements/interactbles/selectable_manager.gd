extends Node

var currently_selected : Selectable

func select(obj : Selectable) -> void:
	if currently_selected != obj:
		if currently_selected:
			currently_selected.select(false)
		currently_selected = obj
		obj.select(true)

func unselect_all() -> void:
	if currently_selected:
		currently_selected.select(false)
		currently_selected = null
