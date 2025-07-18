extends Node2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var speed : float = 500.0
var dotNum: int = 45;
const dot = preload("res://Namarich/Scenes/Objects/Dot.tscn")
const DRAW_TRAJECTORY_MATERIAL = preload("res://Namarich/Material/draw_trajectory_material.tres")
var dir;
var delta;
var dots;

const RIPPLES_MATERIAL = preload("res://Namarich/Material/Ripples.tres")

func _ready() -> void:
	dots = []
	NamarichSignals.redraw_trajectory.connect(redraw)
	NamarichSignals.do_ripples.connect(do_ripples)
	
func _process(delta: float) -> void:
	pass
	#NamarichSignals.redraw_trajectory.connect(redraw)

#func _physics_process(delta: float) -> void:
	
	
func do_ripples(playerPos: Vector2):
	RIPPLES_MATERIAL.set_shader_parameter("playerPos",playerPos)

func redraw(direction : Vector2, pos : Vector2, gravity : float, max_fall_speed: float) -> void:
	#for i in dots:
		#i.queue_free()
	dir = direction
	delta = 1.0/60.0
	dots = []
	
	#var curDot = GameManager.my_instantiate(dot)
	
	var prev_dot_pos : Vector2 = Vector2(0.0, 0.0)
	var dot_pos : Vector2 = prev_dot_pos
	#if (curDot.co)
	print("-----------------------shoot---------------------")
	for i in range(dotNum):
		dir.y += gravity * delta
			
		if direction.y > max_fall_speed:
			direction.y = max_fall_speed
		
		
		dot_pos = pos + prev_dot_pos
		prev_dot_pos += dir * delta * speed
		ray_cast_2d.global_position = dot_pos
		ray_cast_2d.target_position = prev_dot_pos+pos - dot_pos
		#print(ray_cast_2d.global_position," : ", ray_cast_2d.target_position)
		var collision: Vector2 = ray_cast_2d.get_collision_point()
		#if collision:
			#dots.append(collision)
			#print("collision point: ",collision)           
			#break
		
		dots.append(dot_pos)
		
	var dot_unif : PackedVector2Array
	for d in dots:
		dot_unif.append(d)
	DRAW_TRAJECTORY_MATERIAL.set_shader_parameter("dots", dot_unif)
	DRAW_TRAJECTORY_MATERIAL.set_shader_parameter("dotNum", dots.size())
	print(dots.size())
	
	#dots = []
