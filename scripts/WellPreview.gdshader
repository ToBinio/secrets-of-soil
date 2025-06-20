shader_type spatial;

uniform vec3 color : source_color;
uniform float alpha_bias;

void fragment() {
	float dist = length(UV - vec2(0.5));
	float radius = 0.5;

	ALBEDO = color;

	if (dist < radius) {
		ALPHA = (1. - dist) / 2.;
	} else {
		ALPHA = 0.;
	}

	ALPHA -= alpha_bias;
}