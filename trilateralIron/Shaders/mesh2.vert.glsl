#version 450

in vec3 pos;
in vec3 col;
out vec4 fragmentColor;
void main() {
    fragmentColor = vec4(col, 1.);
    gl_Position = vec4(pos, 1.0);
}
