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


int[4] hex_A_Bin(int hex) { //int_A_Ar_Flt
    int _3 = hex % 2, _2 = hex / 2 % 2, _1 = hex / 4 % 2, _0 = hex / 8 % 2;     
    int[] ar_Int = int[](_0, _1, _2, _3);
    
    /*
    const int n_Elems = ar_Int.length();
    float[n_Elems] ar_Flt;
    
    for (int i = 0; i < n_Elems; i++) {
        ar_Flt[i] = float(ar_Int[i]);
    }
    */
    
    return ar_Int; //ar_Flt;
}

void set_Fila(mat4 m, int n_Fila, int[4] ar_Int) { //SOLO AQUI float
    for (int i = 0; i < 4; i++) {
        m[n_Fila][i] = float(ar_Int[i]);
    }
}

void mainImage( out vec4 fragColor, vec2 fragCoord ) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = vec3(0);         
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x);
    
    //int -> vec4
    //int n = 0xF, n1 = 9; //0xF99F
    
    //int n = 1; //0xF00F; //61455
    
    //15
    /*
    int hex = 0xF, _3 = hex % 2, _2 = hex / 2 % 2, _1 = hex / 4 % 2, _0 = hex / 8 % 2; 
    int[] a_Bin = int[](_0, _1, _2, _3); 
    int nElems = a_Bin.length(), bin = 1000 * _0 + 100 * _1 + 10 * _2 + _3;
    */
    //vec4 v = vec4(0);

     //n,n1,n1,n

    int[] ar_Int = hex_A_Bin(0xF), ar_Int1 = hex_A_Bin(9);
    
    mat4 m;
    
    set_Fila(m, 0, ar_Int);





    /*
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            m[i][j] = 0.0;
        }
    }
    */
    
    /*
    mat4 m = mat4(1,1,1,1, //0xF, 15, 0-15
        1,0,0,1, //9
        1,0,0,1,
        1,1,1,1);
    */
    
    col = vec3(m[xPix % 4][yPix % 4]);

    
    
    
    
    //if ([xPix % 4]) col = vec3(1);
    
    
    //if (xPix % 2 == 0) col = vec3(1); //&& yPix % 2 == 0) col = vec3(1);

    // Output to screen
    fragColor = vec4(col,1.0);
}
