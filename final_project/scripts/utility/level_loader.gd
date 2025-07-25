extends Selectable

@onready var activatable_area: InteractableArea = $ActivatableArea
@export var path_to_scene : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if activatable_area.active:
			if selected:
				GlobalSignals.load_level.emit(path_to_scene)
				
	
