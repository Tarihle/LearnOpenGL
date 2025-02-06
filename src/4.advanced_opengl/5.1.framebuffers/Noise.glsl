#version 330 core
out vec4 FragColor;

in vec2 TexCoords;
in vec2 FragCoords;

uniform sampler2D texture1;
//uniform sampler2D screenTexture;
uniform float iTime;

vec2 iResolution = vec2(800, 600);

//void main()
//{
//    FragColor = texture(texture1, TexCoords);
//    vec2 F = gl_Position.xy;
//    vec2 R = vec2(800, 600);
//    vec2 st = (2.0 * F - R)/R.y;
//    st *= 0.65;
//    st = st * 0.21 - st.y * 0.5 + fbmL(st*1.5 - iTime*0.0125 + st.x*0.1 + fbmL(st*3.0 + iTime*0.05));
//    vec3 C = SS(4.5, -0.05, (length(st)-0.05)/fwidth(length(st)-0.05))*vec3(0,1,1);
//    O = vec4(gamma(C),1.0);
//}

float colormap_red(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_green(float x) {
    if (x < 20049.0 / 82979.0) {
        return 0.0;
    } else if (x < 327013.0 / 810990.0) {
        return (8546482679670.0 / 10875673217.0 * x - 2064961390770.0 / 10875673217.0) / 255.0;
    } else if (x <= 1.0) {
        return (103806720.0 / 483977.0 * x + 19607415.0 / 483977.0) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_blue(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 7249.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return 127.0 / 255.0;
    } else if (x < 327013.0 / 810990.0) {
        return (792.02249341361393720147485376583 * x - 64.364790735602331034989206222672) / 255.0;
    } else {
        return 1.0;
    }
}

vec4 colormap(float x) {
    return vec4(colormap_red(x), colormap_green(x), colormap_blue(x), 1.0);
}

// https://iquilezles.org/articles/warp
/*float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float a = textureLod(iChannel0,(p+vec2(0.5,0.5))/256.0,0.0).x;
	float b = textureLod(iChannel0,(p+vec2(1.5,0.5))/256.0,0.0).x;
	float c = textureLod(iChannel0,(p+vec2(0.5,1.5))/256.0,0.0).x;
	float d = textureLod(iChannel0,(p+vec2(1.5,1.5))/256.0,0.0).x;
    return mix(mix( a, b,f.x), mix( c, d,f.x),f.y);
}*/


float rand(vec2 n) { 
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

const mat2 mtx = mat2( 0.80,  0.60, -0.60,  0.80 );

float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.500000*noise( p + iTime  ); p = mtx*p*2.02;
    f += 0.031250*noise( p ); p = mtx*p*2.01;
    f += 0.250000*noise( p ); p = mtx*p*2.03;
    f += 0.125000*noise( p ); p = mtx*p*2.01;
    f += 0.062500*noise( p ); p = mtx*p*2.04;
    f += 0.015625*noise( p + sin(iTime) );

    return f/0.96875;
}

float pattern( in vec2 p )
{
	return fbm( p + fbm( p + fbm( p ) ) );
}

void main()
{
    vec2 uv = FragCoords;
//    vec2 uv = FragCoords/iResolution.x;
	float shade = pattern(uv);
//    FragColor = vec4(colormap(shade).rgb, shade);
//    FragColor = mix(texture(screenTexture, TexCoords), vec4(colormap(shade).rgb, shade), 0.5);
    float average = 0.2126 * colormap(shade).r + 0.7152 * colormap(shade).g + 0.0722 * colormap(shade).b;
//    FragColor = mix(texture(screenTexture, TexCoords), vec4(average, average, average, 1.0), 0.5);
    vec4 text = texture(texture1, TexCoords);
//    FragColor = vec4(clamp(text.r + 0.2126 * colormap(shade).r, 0.0f, 1.0f), clamp(text.g + 0.7152 * colormap(shade).g, 0.0f, 1.0f), clamp(text.b + 0.0722 * colormap(shade).b, 0.0f, 1.0f), 1.0);
    if (text.r >= 0.1 && text.g >= 0.1 && text.b >= 0.1)
        FragColor = vec4(clamp(text.r + average, 0.0f, 1.0f), clamp(text.g + average, 0.0f, 1.0f), clamp(text.b + average, 0.0f, 1.0f), 1.0);
    else
        FragColor = text;
}

/** SHADERDATA
{
	"title": "Base warp fBM",
	"description": "Noise but Pink",
	"model": "person"
}
*/