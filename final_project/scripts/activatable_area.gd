extends Node3D

@onready var area_3d: Area3D = $Area3D

var active : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	active = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.get_meta("character")):
		print("enter")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if (body.get_meta("character")):
		print("leave")
