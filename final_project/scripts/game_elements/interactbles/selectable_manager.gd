extends Node

var currently_selected : Selectable

func select(obj : Selectable) -> void:
	if currently_selected:
		currently_selected.selected = false
	currently_selected = obj
	obj.selected = true
	#print(obj.name)
