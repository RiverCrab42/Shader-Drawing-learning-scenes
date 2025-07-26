extends Node3D
@export var ghost : Node3D
@export var player: CharacterBody3D
const COMMON_MATERIAL = preload("res://assets/materials/ghost_reacting_material.tres")

func _ready() -> void:
	pass
	
func _process(delta : float) -> void:
	print(self.name)
	COMMON_MATERIAL.set_shader_parameter("ghost_pos_w", ghost.global_position)
	RenderingServer.global_shader_parameter_set("player_pos_w", player.position);
