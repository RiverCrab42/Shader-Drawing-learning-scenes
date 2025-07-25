extends Selectable

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var activatable_area: InteractableArea = $ActivatableArea
@export var level: PackedScene
var open : bool
var animation_in_progress : bool

func _ready() -> void:
	open = false
	animation_in_progress = false
	GlobalSignals.load_level.connect(print_)
func _process(delta: float) -> void:
	if open && !animation_in_progress:
		GlobalSignals.load_level.emit(level)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				if open:
					close_chest()
				else:
					open_chest()

func open_chest() -> void:
	if open || animation_in_progress:
		return
	animation_player.play("OPEN")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = true

func close_chest() -> void:
	if !open || animation_in_progress:
		return
	animation_player.play("CLOSE")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = false

func animation_finished(anim_name: StringName) -> void:
	animation_in_progress = false
	
func print_(l:PackedScene):
	print("GODot")
