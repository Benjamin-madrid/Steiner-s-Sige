shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform vec2 screen_size = vec2(1280.0, 720.0); // puedes actualizarla desde GDScript
uniform int pixel_size = 6; // tamaño de cada bloque pixelado
uniform float blur_strength = 1.5; // cuánto difuminar

void fragment() {
	vec2 uv = FRAGCOORD.xy / screen_size;

	// Centro del bloque pixelado
	vec2 block_pos = floor(FRAGCOORD.xy / float(pixel_size)) * float(pixel_size) + float(pixel_size) * 0.5;
	vec2 block_uv = block_pos / screen_size;

	// Box blur: 3x3 muestras alrededor del centro del bloque
	vec3 color = vec3(0.0);
	for (int dx = -1; dx <= 1; dx++) {
		for (int dy = -1; dy <= 1; dy++) {
			vec2 offset = vec2(float(dx), float(dy)) * blur_strength / screen_size;
			color += texture(SCREEN_TEXTURE, block_uv + offset).rgb;
		}
	}
	color /= 9.0;

	ALBEDO = color;
}