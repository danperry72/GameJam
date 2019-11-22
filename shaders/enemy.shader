shader_type canvas_item;
render_mode unshaded;

uniform int colour_mode;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	if ( colour_mode == 1 ) {
		COLOR.r += 1.0;
	}	
	if ( colour_mode == 2 ) {
		COLOR.g += 1.0;
	}	
	if ( colour_mode == 3 ) {
		COLOR.b += 1.0;
	}	
}