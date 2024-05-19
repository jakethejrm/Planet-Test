shader_type canvas_item;

uniform vec4 grass_color : source_color;
uniform vec4 fade_color : source_color;

uniform float border;

uniform float planet_size;
uniform float grass_cutoff;
uniform sampler2D noise;
uniform float noise_scale = 1.0; // Adjust this value to control the smoothness


varying vec2 position;

void vertex() {
	position = VERTEX;
	// Called for every vertex the material is visible on.
}

void fragment() {
	float dist = distance(position, vec2(0.0, 0.0));
    float noise_value = texture(noise, UV).r; // Sample the noise texture
	
	float new_grass_cutoff = planet_size - grass_cutoff + noise_value * noise_scale
	;
	// Called for every pixel the material is visible on.
	if (dist > new_grass_cutoff){
		float grass_amount = (planet_size - dist) / (planet_size - new_grass_cutoff);
		vec4 new_color = mix(grass_color, fade_color, floor(grass_amount / 0.25) * 0.25);
        COLOR = mix(new_color, COLOR, 0.2);
	}
	else if(dist > new_grass_cutoff - border){
		COLOR = mix(COLOR, vec4(0.0, 0.0, 0.0, 1), .5);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
