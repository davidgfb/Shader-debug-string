/*
void _4x4() {
    vec4(0);
    vec4(0);
    vec4(0);
    vec4(0);
}
*/


//hex -> mat4
//mat4 a;


void mainImage( out vec4 fragColor, vec2 fragCoord ) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = vec3(0);         
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x);
    
    
    mat4 m = mat4(1,1,1,1, //0xF, 15, 0-15
        1,0,0,1, //9
        1,0,0,1,
        1,1,1,1);
    
    col = vec3(m[xPix % 4][yPix % 4]);

    
    
    
    //int n = 1; //0xF00F; //61455
    /*
    int hex = 1, _3 = hex % 2, _2 = hex / 2 % 2, _1 = hex / 4 % 2, _0 = hex / 8 % 2; 
    int[] a_Bin = int[](_0, _1, _2, _3); 
    int nElems = a_Bin.length(), bin = 1000 * _0 + 100 * _1 + 10 * _2 + _3;
    */
    //if ([xPix % 4]) col = vec3(1);
    
    
    //if (xPix % 2 == 0) col = vec3(1); //&& yPix % 2 == 0) col = vec3(1);

    // Output to screen
    fragColor = vec4(col,1.0);
}
