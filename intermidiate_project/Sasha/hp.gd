extends AnimatedSprite2D

func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("HP", float(GameManager.health));
