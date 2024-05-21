shader_type canvas_item;

uniform sampler2D gradient;
uniform sampler2D noise : repeat_enable;


void vertex() {
}

void fragment() {
	
vec4 moving = vec4(texture(TEXTURE, UV).rgb * texture(noise, UV + TIME * 0.03).r, texture(TEXTURE, UV).a);
COLOR = vec4(texture(gradient, vec2(moving.r)).rgb, texture(TEXTURE, UV).a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
