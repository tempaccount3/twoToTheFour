shader_type spatial;
render_mode unshaded;

//uniform float size = 1.;
//const float PI = 3.14159;
uniform vec2 border = vec2(-0.5, 0.5);
uniform float front_persistence = 0.9;
uniform vec4 back_color : hint_color = vec4(0, 0, 0.05, 1);
uniform vec4 front_color : hint_color = vec4(1, 0, 0, 1);

varying smooth float z;
void vertex() {
	z = VERTEX.z;
}

vec4 mix_color(vec4 c1, vec4 c2, float strength) {
	return c1 * strength + c2 * (1. - strength);
}

void fragment() {
	float min_z = border.x;
	float max_z = border.y;
	float depth = (z - min_z) / (max_z - min_z);
	if (depth > front_persistence) {
		ALBEDO = front_color.rgb;
		ALPHA = front_color.a;
	}
	else {
		depth /= front_persistence;
		vec4 final_color = mix_color(front_color, back_color, depth);
		ALBEDO = final_color.rgb;
		ALPHA = final_color.a;
	}	
}