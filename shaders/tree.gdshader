shader_type canvas_item;

uniform sampler2D noise: repeat_enable;

void vertex() {
	VERTEX += texture(noise, UV + TIME * 0.05).r * UV.y;
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
