extends Node3D

@export var height_activation : float 
@export var post_effect : Node3D
@export var player_camera : Camera3D
@export var player : Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (height_activation > player_camera.global_position.y):
		post_effect.visible = true
		player.underwater = true
	else:
		post_effect.visible = false
		player.underwater = false
