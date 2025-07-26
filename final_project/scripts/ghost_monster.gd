extends Node3D

@onready var ghost: Node3D = $"."
@export var speed : float = 3.0
@export var target_radius : float = 8.0
var number_targets : int = 0
@export var target : Node3D
@export var targets : Array[Node3D]
var time : float = 0
var see : bool = 0
#@onready var target: CharacterBody3D = $"../CharacterBody3D"

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	if (ghost == null || target == null) :
		return;
	
	if (ghost.global_position - target.global_position).length() <= target_radius:
		ghost.global_position += (target.global_position - ghost.global_position).normalized() * speed * delta
		see = 1
		#GHOST.set_shader_parameter("see", see)
		
		time += delta
		#if time >= 100*delta:
			#var ghost_clone = GHOST.instantiate()
			#get_tree().root.add_child(ghost_clone)
			#(ghost_clone as Node3D).global_position = ghost.global_position + Vector3(20.0*randf()-10.0, 20.0*randf()-10.0, 20.0*randf()-10.0)
			#ghost_clone.targets = targets
			#ghost_clone.target = target
			#time = -600 * delta
			#ghost_clone.speed = speed / 2
			#ghost_clone.target_radius = target_radius / 2
			#ghost_clone.scale = ghost.scale / 2
			#ghost_clone.time = -900 * delta
			#print("clon sozdan")
			
			
		ghost.look_at(target.global_position);
		ghost.rotate_object_local(Vector3(0,1,0),90.0);
		
	else:
		see = 0
		#GHOST.set_shader_parameter("see", see)
		if (ghost.global_position - targets[number_targets].global_position).length() > 0.1:
			ghost.global_position += (targets[number_targets].global_position - ghost.global_position).normalized() * speed * delta
		else:
			number_targets += 1
			if number_targets > len(targets) - 1:
				number_targets = 0
		
		ghost.look_at(targets[number_targets].global_position);
		ghost.rotate_object_local(Vector3(0,1,0),90.0);
