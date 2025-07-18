extends ColorRect

const HEALTH_MATERIAL = preload("res://VDVVAH/materials/health_material.tres")
const ARROW_MATERIAL = preload("res://VDVVAH/materials/arrow_material.tres")

func _process(delta: float) -> void:
	RenderingServer.global_shader_parameter_set("HP", float(GameManager.health))
	RenderingServer.global_shader_parameter_set("MAX_HP", 5.)
	ARROW_MATERIAL.set_shader_parameter("number_of_arrows", float(GameManager.arrows))
	
