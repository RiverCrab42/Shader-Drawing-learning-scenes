extends Node3D
const GHOST = preload("res://Namarich/scenes/ghost.tscn")
@onready var player: CharacterBody3D = $"../CharacterBody3D"
const COMMON_MATERIAL = preload("res://assets/materials/common.tres")
@onready var ghost: Node3D = $"../Ghost2"
#@export var ghost: preload("res://Namarich/scenes/ghost.tscn")
func _ready() -> void:
	pass
	
func _process(delta : float) -> void:
	COMMON_MATERIAL.set_shader_parameter("ghost_pos_w", ghost.global_position)
	RenderingServer.global_shader_parameter_set("player_pos_w", player.position);
