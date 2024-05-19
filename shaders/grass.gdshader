shader_type canvas_item;
render_mode world_vertex_coords;

uniform float wind_speed = 1;
uniform float distance_threshold = 100;

global uniform vec2 player_location;

void vertex() {
	float player_distance = distance(VERTEX, player_location);
	
	if (player_distance < distance_threshold){
		float diff_x = player_location.x - VERTEX.x;
		float diff_y = player_location.y - VERTEX.y;
	
		VERTEX += (MODEL_MATRIX * vec4(0.0, 8.0, 0.0, 0.0)).xy;
	}
	else{
		VERTEX.x += (inverse(MODEL_MATRIX) * vec4(sin(TIME + VERTEX.x) * -(UV.y -1.0) * wind_speed, 0.0, 0.0, 0.0)).x;
		VERTEX.y += (inverse(MODEL_MATRIX) * vec4(0.0 , sin(TIME + VERTEX.y) * -(UV.y -1.0) * wind_speed, 0.0, 0.0)).x;
	}
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
