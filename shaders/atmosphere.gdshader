shader_type canvas_item;

uniform sampler2D atmosphere_noise : repeat_enable;
uniform sampler2D atmosphere_noise2 : repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float x = UV.x + cos(TIME) * 0.01;
	float y = UV.y + sin(TIME) * 0.01;
	vec4 noise = texture(atmosphere_noise, vec2(x,y));
	vec4 noise2 = texture(atmosphere_noise2, UV + (TIME * 0.2));
	
	COLOR =  mix(mix(COLOR, COLOR * noise.r, 1), noise2 * COLOR.a, .5);
	
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
