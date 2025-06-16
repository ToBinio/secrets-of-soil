shader_type spatial;

uniform vec3 color : source_color;
uniform float alpha_bias;

void fragment() {
	float dist = length(UV - vec2(0.5));
	float radius = 0.5;
	float line_width = 0.005;
	vec3 line_color = vec3( 1.0, 1.0, 0.0 );

	ALBEDO = color;

	if (dist > radius - line_width && dist < radius) {
		ALBEDO = color;
	} else if (dist < radius) {
		ALPHA = dist + 0.2;
	} else {
		ALPHA = 0.;
	}

	ALPHA -= alpha_bias;
}