extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_enum("slime", "ghost") var enemy_type : String
@export var spawn_time = 5

var time : float

var spawned = false
var collected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > spawn_time:
		if !collected:
			visible = true
		if !spawned:
			animation_player.play("summon")
			spawned = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is CharacterBody2D and spawned):
		collected = true
		GlobalSignals.collected_apple.emit()
		queue_free() # Replace with function body.
