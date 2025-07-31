extends AnimatedSprite2D
var direction = -1


const MARK = preload("res://Sasha/scenes/Mark.tres")
const MARK_X = preload("res://Sasha/scenes/Mark.tscn")


@onready var Player: Sasha = $"../CharacterBody2D2"

var time : float = 0
var TIME : float = 0
var TiMe2 : float = 0
var vremya : float = 0
var time_uron : float = 0
var die_time : float = 0
var speed : float = 0
var clon : int = 0
var damage_to_player : float = 0
var level_viewport : Vector2i
var uron : int = 0
var zdox : int = 0

@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var down_right_ray: RayCast2D = $DownRightRay
@onready var down_left_ray: RayCast2D = $DownLeftRay
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var SPEED = 50.0
@export var health : float = 42
@export var clon_life_time : float = 5
@export var clon_spawn_time : float = 7
@export var clon_when_die : int = 2

func _ready() -> void:
	level_viewport = get_viewport_rect().size

func _process(delta: float) -> void:
	
	TIME += delta
	time += delta
	TiMe2 += delta
	vremya += delta
	
	if uron == 1:
		time_uron += delta
		if time_uron >= 0.42:
			uron = 0
			time_uron = 0
			
	if zdox == 1:
		die_time += delta
		if die_time >= 0.05:
			animation_player.play("die")
			area_2d.collision_mask = 0
			SPEED = 0.0
			animation_player.animation_finished.connect(die)
			for i in range(clon_when_die):
				var mark = GameManager.my_instantiate(MARK_X)
				get_tree().root.add_child(mark)
				mark.global_position = global_position + Vector2(randf()*300-150,randf()*300-150)
				(mark as Node2D).scale = scale
				(mark as Node2D).clon = 1
				(mark as Node).health = health
				print("clon sozdan")
			if clon == 1:
				print("clon zdox")
			else:
				print("nevozmogno")
			die_time = -3468653434856
	
	if TiMe2 >= clon_life_time:
		if clon == 1 && damage_to_player <= 0.42:
			zdox = 1
		TiMe2 = 0
	
	if vremya > 2:
		if randf() <= 0.5:
			animated_sprite_2d.flip_h = true
		else:
			animated_sprite_2d.flip_h = false
		vremya = 0
	
	if time >= clon_spawn_time:
		var mark = GameManager.my_instantiate(MARK_X)
		get_tree().root.add_child(mark)
		mark.global_position = global_position + Vector2(randf()*300-150,randf()*300-150)
		(mark as Node2D).scale = scale
		(mark as Node2D).clon = 1
		(mark as Node).health = health
		print("clon sozdan")
		time = 0
		
	if time < clon_spawn_time*randf():
		speed = SPEED*2*(randf()+1)*(abs(sin(TIME*3))+1)
		position += (Vector2(3*cos(TIME*randf())*randf(), (randf()+1)*sin(TIME*randf())*cos(TIME*1.1))).normalized()*speed*delta
	else:
		speed = SPEED*(randf()*abs(sin(TIME))+1)*(1-cos(TIME*1.42))/(randf()+0.042)
		position += (Vector2(randf()-0.5, cos(TIME*randf()))).normalized()*speed*delta
	
	MARK.set_shader_parameter("uron", uron)
	MARK.set_shader_parameter("zdox", zdox)

func get_hit() -> void:
	health -= 1
	if health < 0.1:
		zdox = 1
		print("za shto?")
	else:
		animation_player.play("hit")
		uron = 1
		print("bolno")

func die(anim_name: StringName) -> void:
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Arrow:
		var arr = area.get_parent() as Arrow
		if !arr.stuck:
			get_hit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()
		damage_to_player += 1
	
func _physics_process(delta: float) -> void:
	if global_position.x > level_viewport.x:
		global_position.x = 0.0
	elif global_position.x < 0.0:
		global_position.x = level_viewport.x
	
	if global_position.y > level_viewport.y:
		global_position.y = 0.0
	elif global_position.y < 0.0:
		global_position.y = level_viewport.y
