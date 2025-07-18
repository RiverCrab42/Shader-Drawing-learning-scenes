extends Node2D

@export var SPEED = 40.0

var direction = -1
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var down_right_ray: RayCast2D = $DownRightRay
@onready var down_left_ray: RayCast2D = $DownLeftRay
@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var health : int = 4

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _ready() -> void:
	animated_sprite_2d.play("idle")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("kill"):
		animation_player.play("die")
		area_2d.collision_mask = 0
		SPEED = 0.0
		animation_player.animation_finished.connect(die)
	$Label.text = str(health)
	position.x += direction * SPEED * delta
	if (right_ray.is_colliding() or not(down_right_ray.is_colliding())):
		var col = right_ray.get_collider()
		if (not right_ray.is_colliding() or not col.is_in_group("player")):
			direction = -1
			animated_sprite_2d.flip_h = false
		
	if (left_ray.is_colliding() or not(down_left_ray.is_colliding())):
		var col = left_ray.get_collider()
		if (not left_ray.is_colliding() or not col.is_in_group("player")):
			direction = 1
			animated_sprite_2d.flip_h = true

func get_hit(damage) -> void:
	health -= damage
	if health <= 0:
		animation_player.play("die")
		area_2d.collision_mask = 0
		SPEED = 0.0
		animation_player.animation_finished.connect(die)
	else:
		animation_player.play("hit")

func die(anim_name: StringName) -> void:
	if get_parent() is Wave:
		get_parent().die += 1
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is ArrowNew:
		var arr = area.get_parent() as ArrowNew
		if !arr.stuck:
			get_hit(1 + int(arr.get_meta("fire")))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()
