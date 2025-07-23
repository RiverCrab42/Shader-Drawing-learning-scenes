extends StaticBody2D


func _process(delta: float) -> void:
	if Input.is_action_pressed("moveDown"):
		$Collision.disabled = true
	else:
		$Collision.disabled = false
