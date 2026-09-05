shader_type canvas_item;

// Controls how white the sprite is (0.0 = normal texture, 1.0 = fully white)
uniform float white_progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	// Mix the original texture color with pure white based on white_progress
	vec3 final_color = mix(tex_color.rgb, vec3(1.0, 1.0, 1.0), white_progress);
	
	// Keep the original alpha channel so transparency stays intact
	COLOR = vec4(final_color, tex_color.a);
}