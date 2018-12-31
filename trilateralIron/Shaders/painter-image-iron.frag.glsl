#version 450
uniform sampler2D tex;
in vec2 texCoord;
in vec4 fragmentColor;
out vec4 FragColor;
void main() {
	vec4 texcolor = texture(tex, texCoord) * fragmentColor;
	texcolor.rgb *= fragmentColor.a;
	FragColor = texcolor;
}
