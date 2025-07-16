extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignals.game_over.connect(open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open() -> void:
	visible = true
	Engine.time_scale = 0.0005

func _on_button_pressed() -> void:
	Engine.time_scale = 1.0
	GameManager.reset()
	var tree := get_tree()
	var scene_path := tree.current_scene.scene_file_path
	get_tree().unload_current_scene()
	tree.call_deferred("unload_current_scene")
	tree.call_deferred("change_scene_to_file", scene_path)
