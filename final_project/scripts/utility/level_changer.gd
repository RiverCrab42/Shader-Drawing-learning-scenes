extends AnimationPlayer

var level_to_load : String

func _ready() -> void:
	GlobalSignals.load_level.connect(level_load)

func level_load(path_to_scene : String) -> void:
	play("TP")
	level_to_load = path_to_scene;
	animation_finished.connect(final_load, CONNECT_ONE_SHOT)

func final_load(anim_name : StringName) -> void:
	get_tree().change_scene_to_file(level_to_load)
