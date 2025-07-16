extends Node2D

@export var SPEED = 40.0

@onready var animated_sprite_2d: AnimatedSprite2D = $"."
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var area_2d: Area2D = $Area2D

@export var health : int = 1

var curr_time = 0.0
@export var player_enable_time = 2.0
var is_alive = true;

func _ready() -> void:
	animated_sprite_2d.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curr_time += delta
	if GameManager.player:
		var direction = (GameManager.player.global_position - global_position).normalized();
		position += direction * SPEED * delta
		if (direction.x > 0 and is_alive):
			animated_sprite_2d.flip_h = true
		if (direction.x < 0 and is_alive):
			animated_sprite_2d.flip_h = false

func get_hit() -> void:
	health -= 1
	if health == 0:
		is_alive = false
		animation_player.play("die")
		area_2d.collision_mask = 0
		SPEED = 0.0
		animation_player.animation_finished.connect(die)
	else:
		animation_player.play("hit")

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
