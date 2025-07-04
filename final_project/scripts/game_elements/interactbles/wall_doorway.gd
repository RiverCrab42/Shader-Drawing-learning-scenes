extends Selectable

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var activatable_area: InteractableArea = $ActivatableArea

var open : bool
var animation_in_progress : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open = false
	animation_in_progress = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				if open:
					close_door()
				else:
					open_door()

func open_door() -> void:
	if open || animation_in_progress:
		return
	animation_player.play("door_open")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = true

func close_door() -> void:
	if !open || animation_in_progress:
		return
	animation_player.play("door_close")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = false

func animation_finished(anim_name: StringName) -> void:
	animation_in_progress = false
