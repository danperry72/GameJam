shader_type canvas_item;

uniform float radius;
uniform int colour_mode;
uniform vec2 position;
void fragment() {
    COLOR = texture(TEXTURE, UV);
	vec4 OLD_COLOR = COLOR;
	vec2 res = 1.0 / SCREEN_PIXEL_SIZE;

	if ( colour_mode == 1 ) { 
		if (abs(distance(position, FRAGCOORD.xy)) < radius) {
			COLOR.r += 0.2;
		} 
	} else {
	if ( colour_mode == 2 ) { 
		if (abs(distance(position, FRAGCOORD.xy)) < radius) {
			COLOR.g += 0.2;
		} 
	} else {
		if (abs(distance(position, FRAGCOORD.xy)) < radius) {
			COLOR.b += 0.2;
		}  }}
}