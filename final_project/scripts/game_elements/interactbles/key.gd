extends Selectable

@onready var activatable_area: InteractableArea = $ActivatableArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func select(state : bool) -> void:
	selected = state

func _process(delta: float) -> void:
	rotate_y(-delta)
	if Input.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				pick_up()

func pick_up() -> void: 
	animation_player.animation_finished.connect(pick_up_animation_finished)
	animation_player.play("pick_up")

func pick_up_animation_finished(anim_name: StringName) -> void:
	queue_free()
