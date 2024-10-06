shader_type canvas_item;

uniform vec4 color1: source_color;
uniform vec4 color2: source_color;
uniform float t;

void fragment() {
    vec4 c = texture(TEXTURE, UV);
    c.rgb = (1. - t) * color1.rgb + t * color2.rgb;
    COLOR = c;
}