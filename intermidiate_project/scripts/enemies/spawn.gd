extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var SLIME : PackedScene
@export var GHOST_IDLE : PackedScene
#const SLIME = preload("res://scenes/enemies/slime.tscn")
#const GHOST_IDLE = preload("res://scenes/enemies/ghost_idle.tscn")

@export_enum("slime", "ghost") var enemy_type : String
@export var spawn_time : float

var time : float

var activated : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > spawn_time:
		visible = true
		if !activated:
			animation_player.play("summon")
			animation_player.animation_finished.connect(summon)
			activated = true

func summon(anim_name : String) -> void:
	match enemy_type:
		"slime":
			var slime = GameManager.my_instantiate(SLIME)
			get_tree().root.add_child(slime)
			slime.global_position = global_position
			queue_free()
		"ghost":
			var ghost = GameManager.my_instantiate(GHOST_IDLE)
			get_tree().root.add_child(ghost)
			ghost.global_position = global_position
			queue_free()
