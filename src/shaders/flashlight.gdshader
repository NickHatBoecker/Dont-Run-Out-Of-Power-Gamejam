shader_type canvas_item;

uniform vec2 player_position;
uniform float multiplier = 0.56; // res 16/9 -> multiplier = 9/16
uniform vec4 color: source_color = vec4(0, 0, 0, 1); // Some dark color
uniform float dis1 = 0.05;
uniform float dis2 = 0.00;

void fragment() {
    float transparency = 0.0;

    float playerX = (player_position.x - 0.015);
    float playerY = (player_position.y) * multiplier;

    // UV = Position of the current pixel
    float val = distance(
        vec2(UV.x, UV.y * multiplier),
        vec2(playerX, playerY)
    );

    if (val < dis1) {
        transparency = 0.0;
    } else if (val < dis2) {
        transparency = 0.5;
    } else {
        transparency = 1.0;
    }

    // COLOR = Color of the current pixel
    COLOR = vec4(color.x, color.y, color.z, transparency);
}