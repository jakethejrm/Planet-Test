shader_type canvas_item;

uniform sampler2D gradient : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(texture(gradient, SCREEN_UV + TIME * 0.5).rgb, texture(TEXTURE, UV).a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
