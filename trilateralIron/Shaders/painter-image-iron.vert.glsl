#version 450
in vec3 pos;
in vec2 uvs;
in vec4 col;
uniform mat4 WVP;
out vec2 texCoord;
out vec4 fragmentColor;
void main() {
	gl_Position = WVP * vec4( pos, 1.0);
	texCoord = uvs;
	fragmentColor = col;
}
