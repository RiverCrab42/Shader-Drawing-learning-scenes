extends Node3D

@export var height_activation : float 
@export var post_effect : MeshInstance3D
@export var player_camera : Camera3D
@export var player : Node3D
@export var drown_time = 10.0;

var drowning_timer : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (height_activation > player_camera.global_position.y):
		drowning_timer += delta
		post_effect.visible = true
		player.underwater = true
	else:
		drowning_timer = 0.0
		post_effect.visible = false
		(player as Player).underwater = false
	(post_effect.get_surface_override_material(0) as ShaderMaterial).\
		set_shader_parameter("underwater_timer", drowning_timer)
	if drowning_timer > drown_time:
		GlobalSignals.player_died.emit()
