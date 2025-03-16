shader_type canvas_item;

uniform float sway_strength : hint_range(0.0, 10.0) = 5.0; // How much the grass sways
uniform float sway_speed : hint_range(0.0, 10.0) = 2.0;    // Speed of the sway
uniform float sway_frequency : hint_range(0.0, 10.0) = 5.0; // How frequently the grass moves
uniform float height_falloff : hint_range(0.0, 5.0) = 1.5; // How much sway reduces toward the base

void fragment() {
    vec2 uv = UV; // Copy UV

    // Calculate horizontal sway using sine wave
    float sway = sin(TIME * sway_speed + uv.y * sway_frequency) * sway_strength;

    // Reduce sway toward the bottom (base of grass)
    sway *= smoothstep(1.0, 0.2, uv.y * height_falloff);

    // Modify the texture sampling position
    vec2 displaced_uv = uv + vec2(sway * 0.01, 0.0);

    COLOR = texture(TEXTURE, displaced_uv);
}