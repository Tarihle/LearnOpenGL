#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D screenTexture;

//No effect
//void main()
//{
//    vec3 col = texture(screenTexture, TexCoords).rgb;
//    FragColor = vec4(col, 1.0);
//} 

//Gray Scale
//void main()
//{
//    FragColor = texture(screenTexture, TexCoords);
//    float average = 0.2126 * FragColor.r + 0.7152 * FragColor.g + 0.0722 * FragColor.b;
//    FragColor = vec4(average, average, average, 1.0);
//} 

//Inversion
//void main()
//{
//    FragColor = vec4(vec3(1.0 - texture(screenTexture, TexCoords)), 1.0);
//} 

//Vignette
void main()
{
    float testX = TexCoords[0];
    float testY = TexCoords[1];
    float sig = 0.3;

    float div = pow(2.71828, (0.5 + 0.5) / (2 * sig * sig)) / (2 * 3.14159265 * sig * sig);

    if (testX > 0.5)
    {
        testX = 0.5 - (testX - 0.5);
    }  
    if (testY > 0.5)
    {
        testY = 0.5 - (testY - 0.5);
    }

    float eFac = pow(2.71828, (testX + testY) / (2 * sig * sig));


    vec3 col = texture(screenTexture, TexCoords).rgb;
    //col *= testX + testY;
    col *= eFac / (2 * 3.14159265 * sig * sig);
    col /= div;
    FragColor = vec4(col, 1.0);
} 

///* KERNEL */

//Sharpen
//float kernel[9] = float[](
//    -1, -1, -1,
//    -1,  9, -1,
//    -1, -1, -1
//);
//Box Blur
//float kernel[9] = float[](
//    1.0 / 9, 1.0 / 9, 1.0 / 9,
//    1.0 / 9, 1.0 / 9, 1.0 / 9,
//    1.0 / 9, 1.0 / 9, 1.0 / 9  
//);
//Gaussian Blur
//float kernel[9] = float[](
//    1.0 / 16, 2.0 / 16, 1.0 / 16,
//    2.0 / 16, 4.0 / 16, 2.0 / 16,
//    1.0 / 16, 2.0 / 16, 1.0 / 16  
//);
//Edge Detection
//float kernel[9] = float[](
//    1.0, 1.0, 1.0,
//    1.0, -8.0, 1.0,
//    1.0, 1.0, 1.0  
//);
//Test
//float kernel[9] = float[](
//    0.0425, 0.0825, 0.0425,
//    0.0825, 0.5, 0.0825,
//    0.0425, 0.0825, 0.0425  
//);

//const float offset = 1.0 / 300.0;  
//
//void main()
//{
//    vec2 offsets[9] = vec2[](
//        vec2(-offset,  offset), // top-left
//        vec2( 0.0f,    offset), // top-center
//        vec2( offset,  offset), // top-right
//        vec2(-offset,  0.0f),   // center-left
//        vec2( 0.0f,    0.0f),   // center-center
//        vec2( offset,  0.0f),   // center-right
//        vec2(-offset, -offset), // bottom-left
//        vec2( 0.0f,   -offset), // bottom-center
//        vec2( offset, -offset)  // bottom-right    
//    );
//    
//    vec3 sampleTex[9];
//    for(int i = 0; i < 9; i++)
//    {
//        sampleTex[i] = vec3(texture(screenTexture, TexCoords.st + offsets[i]));
//    }
//    vec3 col = vec3(0.0);
//    for(int i = 0; i < 9; i++)
//        col += sampleTex[i] * kernel[i];
//    
//    FragColor = vec4(col, 1.0);
//}  