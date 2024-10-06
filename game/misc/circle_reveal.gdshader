shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_nearest;

uniform float radius = 150;
uniform vec2 offset = vec2(0, 270);

uniform vec4 color: source_color;

void fragment() {
    vec4 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgba;
	vec2 texture_size = vec2(textureSize(SCREEN_TEXTURE, 0));
	vec2 pos = SCREEN_UV * texture_size;
	//vec2 pos = vec2(SCREEN_UV.x * texture_size.x, SCREEN_UV.y * texture_size.y);
	vec2 pos_centered = pos - texture_size * .5 - offset;
	float r2 = dot(pos_centered, pos_centered);
	if (r2 < radius * radius) {
		COLOR = c;
	} else {
		COLOR = color;
	}
}