shader_type canvas_item;

uniform vec2 dimensions;
uniform float grass_size = 1;
uniform float border_size = 1;
uniform vec4 grass_color : source_color;
uniform vec4 fade_color : source_color;
uniform sampler2D noise : repeat_enable;

varying vec2 vertex_pos;

void vertex() {
	vertex_pos = VERTEX;
}

void fragment() {
	
	float noise_amount = texture(noise, UV).r;
	float x = (dimensions.x / 2.0) - abs(vertex_pos.x);
	float y = (dimensions.y / 2.0);
	if (x< noise_amount * 10.0){
		COLOR = vec4(0.0);
	}
	else if (y - vertex_pos.y < + noise_amount * 10.0){
		COLOR = vec4(0.0);
	}
	else if (y + vertex_pos.y< grass_size + (noise_amount * 10.0)){
		float grass_amount = y + vertex_pos.y;
		
		COLOR = mix(grass_color, fade_color, floor(grass_amount/ (grass_size + (noise_amount * 10.0)) / 0.25) * 0.25);
	}
	else if (y + vertex_pos.y < grass_size + border_size + (noise_amount * 10.0)){
		COLOR = mix(COLOR, vec4(0.0, 0.0, 0.0, 1), .5);
	}
}