@tool
extends CompositorEffect
class_name RenderingEffectDepthCapture

var rd : RenderingDevice
var nearest_sampler : RID
var shader : RID
var pipeline : RID

func _init():
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	RenderingServer.call_on_render_thread(_initialize_computer)

func _initialize_computer() -> void:
	rd = RenderingServer.get_rendering_device()
	if !rd:
		print("rd not found")
		return
	var sampler_state : RDSamplerState = RDSamplerState.new()
	sampler_state.min_filter = RenderingDevice.SAMPLER_FILTER_NEAREST
	sampler_state.mag_filter = RenderingDevice.SAMPLER_FILTER_NEAREST
	nearest_sampler = rd.sampler_create(sampler_state)
	
	var shader_file: RDShaderFile = load("res://compositor/scripts/re_depth_capture.glsl")
	var shader_spirv : RDShaderSPIRV = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if shader.is_valid():
			rd.free_rid(shader)

func _render_callback(p_effect_callback_type, p_render_data):
	if not enabled: return
		
	if p_effect_callback_type != EFFECT_CALLBACK_TYPE_POST_TRANSPARENT: return
		
	if not rd:
		push_error("No rendering device")
		return
		
	var render_scene_buffers : RenderSceneBuffersRD = p_render_data.get_render_scene_buffers()
	if not render_scene_buffers:
		push_error("No buffer to render to")
		return
	
	var size : Vector2i = render_scene_buffers.get_internal_size()
	if size.x == 0 and size.y == 0:
		push_error("Rendering to 0x0 buffer")
		return
	
	var x_groups = (size.x - 1) / 8 + 1
	var y_groups = (size.y - 1) / 8 + 1
	var z_groups = 1
	
	for view in range(render_scene_buffers.get_view_count()):
		var depth_tex : RID = render_scene_buffers.get_depth_layer(view)
		var color_tex : RID = render_scene_buffers.get_color_layer(view)
		
		var depth_uniform : RDUniform = RDUniform.new()
		depth_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
		depth_uniform.binding = 0
		depth_uniform.add_id(nearest_sampler)
		depth_uniform.add_id(depth_tex)
		
		var depth_copy_uniform : RDUniform = RDUniform.new()
		depth_copy_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
		depth_copy_uniform.binding = 1
		depth_copy_uniform.add_id(color_tex)
		
		var params: PackedFloat32Array = PackedFloat32Array()
		params.push_back(size.x)
		params.push_back(size.y)
		var params_buffer: RID = rd.storage_buffer_create(params.size()*4, params.to_byte_array())
		
		var params_uniform: RDUniform = RDUniform.new()
		params_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
		params_uniform.binding = 2
		params_uniform.add_id(params_buffer)
		
		var uniform_set: RID = rd.uniform_set_create([depth_uniform, depth_copy_uniform, params_uniform], shader, 0)
		
		var compute_list := rd.compute_list_begin()
		rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
		rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
		rd.compute_list_dispatch(compute_list, x_groups, y_groups, 1)
		rd.compute_list_end()
		
		rd.free_rid(uniform_set)
