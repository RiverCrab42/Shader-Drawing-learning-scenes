#[compute]
#version 450

layout (local_size_x = 8, local_size_y = 8, local_size_z = 1) in;
// sampler and image buffer
layout (set = 0, binding = 0) uniform sampler2D depth_buffer;
//output texture
layout (rgba16f, set = 0, binding = 1) uniform restrict writeonly image2D depth_copy;

layout (set = 0, binding = 2, std430) restrict buffer Params {
    vec2 resolution;
} params;

//the code we want to execute in each invocation
void main() {
    ivec2 xy = ivec2(gl_GlobalInvocationID.xy);
    vec2 uv = vec2(xy) / params.resolution;
    vec4 depth = texture(depth_buffer, uv);
    imageStore(depth_copy, xy, vec4(depth.r, 0.0, 0.0, 1.0));
}
