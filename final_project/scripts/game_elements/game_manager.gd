extends Node
@onready var level_loader: AnimationPlayer = $LevelLoader
var level_to_load : PackedScene

func _ready() -> void:
	GlobalSignal.load_level.connect(load_level)


func load_level(level : PackedScene) -> void:
	level_loader.play("TP")
	level_to_load = level;
	level_loader.animation_finished.connect(final_load, CONNECT_ONE_SHOT)

func final_load() -> void:
	load_level(level_to_load)
