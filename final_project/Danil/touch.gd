extends Selectable

@onready var activatable_area: InteractableArea = $ActivatableArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var outline: MeshInstance3D = $"../postprocessing/outline"
@onready var moebius: MeshInstance3D = $"../postprocessing/moebius"

@onready var pdocb: CheckBox = $"../CanvasLayer/Panel/PDOCB"
@onready var docb: CheckBox = $"../CanvasLayer/Panel/DOCB"
@onready var nocb: CheckBox = $"../CanvasLayer/Panel/NOCB"
@onready var panel: Panel = $"../CanvasLayer/Panel"
@onready var camera_3d: Camera3D = $"../CharacterBody3D/Camera3D"

var outline_mat : ShaderMaterial
var open : bool
var animation_in_progress : bool
var paused : bool = false

func _ready() -> void:
	open = false
	outline_mat = outline.get_surface_override_material(0)
	animation_in_progress = false
	outline.visible = true
	moebius.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				if open:
					off()
				else:
					on()
	if event.is_action_pressed("pause"):
		paused = !paused
	if paused:
		panel.visible = true
		camera_3d.active = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		panel.visible = false
		camera_3d.active = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	outline_mat.set_shader_parameter("primitive_depth_edge", pdocb.button_pressed)
	outline_mat.set_shader_parameter("depth_edge", docb.button_pressed)
	outline_mat.set_shader_parameter("normal_edge", nocb.button_pressed)

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
	outline.visible = !open
	moebius.visible = open
	
