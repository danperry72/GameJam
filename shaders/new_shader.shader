shader_type canvas_item;
render_mode unshaded;
uniform float radius;
uniform int colour_mode;
void fragment() {
    COLOR = texture(TEXTURE, UV);
	vec4 OLD_COLOR = COLOR;
	float X = UV.x - 0.5;
	float Y = UV.y - 0.5;
	
	if ( colour_mode == 1 ) { 
		if (abs(distance(vec2(0.5,0.5), UV.xy)) < radius) {
			COLOR.r = 1.0 //((0.005*radius) / (sqrt(X * X + Y * Y))) ;
		} 
	} else {
	if ( colour_mode == 2 ) { 
		if (abs(distance(vec2(0.5,0.5), UV.xy)) < radius) {
			COLOR.g = 1.0 //((0.005*radius) / (sqrt(X * X + Y * Y))) ;
		} 
	} else {
		if (abs(distance(vec2(0.5,0.5), UV.xy)) < radius) {
			COLOR.b = 1.0 //((0.005*radius) / (sqrt(X * X + Y * Y))) ;
		}  }}
}