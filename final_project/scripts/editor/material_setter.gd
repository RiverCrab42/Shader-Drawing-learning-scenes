@tool
extends EditorScript

var object_groups : Array
var material_to_set = preload("res://solution/shaders/depth_example.tres")
func recursive_make_editable(obj : Node) -> void:
	var parent = obj.get_parent()
	if parent:
		parent.set_editable_instance(obj, true)
	for child in obj.get_children():
		recursive_make_editable(child)

func recursive_set_material(obj : Node) -> void:
	if obj is MeshInstance3D:
		print((obj as MeshInstance3D).mesh.surface_get_material(0))
		print(obj.name)
		if obj.get_surface_override_material_count() == 0:
			print("failed")
		else:
			obj.set_surface_override_material(0, material_to_set)
	for child in obj.get_children():
		recursive_set_material(child)

func _run() -> void:
	#var selected_material = load(EditorInterface.get_selected_paths()[0]) as ShaderMaterial
	var selected : Array = EditorInterface.get_selection().get_selected_nodes()
	for obj in selected:
		recursive_make_editable(obj)
	for obj in selected:
		recursive_set_material(obj)
	
