extends Selectable

@onready var activatable_area: InteractableArea = $ActivatableArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var outline: MeshInstance3D = $postprocessing/outline

var open : bool
var animation_in_progress : bool

func _ready() -> void:
	open = false
	animation_in_progress = false
	outline.set_instance_shader_parameter("moebius", false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				if open:
					off()
				else:
					on()

func on() -> void:
	if open || animation_in_progress:
		return
	animation_player.play("ON")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = true

func off() -> void:
	if !open || animation_in_progress:
		return
	animation_player.play("OFF")
	animation_in_progress = true
	animation_player.animation_finished.connect(animation_finished, CONNECT_ONE_SHOT)
	open = false

func animation_finished(anim_name: StringName) -> void:
	animation_in_progress = false
	outline.set_instance_shader_parameter("moebius", open)
	
