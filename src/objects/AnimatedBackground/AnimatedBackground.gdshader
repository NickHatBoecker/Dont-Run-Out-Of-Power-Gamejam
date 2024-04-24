shader_type canvas_item;


uniform float speed;
uniform float opacity = 1;


void fragment () {
	COLOR = texture(TEXTURE, vec2(UV.x - TIME * speed, UV.y - TIME * speed));
    COLOR.a *= opacity;  // Ändere den Alpha-Wert (Transparenz) auf 0.5 (50%)
}