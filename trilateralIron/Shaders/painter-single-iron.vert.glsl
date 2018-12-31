#version 450
in vec3 pos;
uniform mat4 WVP;
void main() {
	gl_Position =  WVP * vec4(pos, 1.0);
}