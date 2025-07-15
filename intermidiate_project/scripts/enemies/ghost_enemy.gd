extends AnimatedSprite2D

var player : Node2D
@export var speed : float
@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	global_position += speed * direction * delta
