extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() != null:
		if area.get_parent() is ArrowNew:
			area.get_parent().fire()
