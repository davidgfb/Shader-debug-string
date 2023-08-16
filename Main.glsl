int potia(int x, int y) {
    return int(pow(float(x), float(y)));
}

int[4] a_Ar_Noton(int dec, int base) { //SOLO para binario?
    /*
    PRE: n < 5, n € Z
    USO: int[] ar_Bin = a_Ar_Noton(bin, 2), ar_Hex = a_Ar_Noton(hex, 16);
    posiblemente mas lento q dec_A_Ar_Dec
    */    
    int _3 = dec % base, _2 = dec / base % base, _1 = dec / potia(base, 2) % base, 
        _0 = dec / potia(base, 3) % base;  
    
    return int[](_0, _1, _2, _3);
}

int _1e3 = 1000, _1e2 = 100, _1e1 = 10;

int[4] separa_Decs(int dec) { //dec_A_Ar_Decs
    /*
    int -> ar, int[4]
    2345 = 2 * 1e3 - 3 * 1e2 - 4 * 1e1 - 5;    
    int(1e3), _1e2 = int(1e2), _1e1 = int(1e1),
    2345 / 1000 = 2, 2345 - 2000 -> 345 / 100 = 3 
    2345 - 2000 -> 345 - 300 -> 45 / 10 = 4, 2345 - 2000 -> 345 - 300 -> 45 - 40 = 5   
    */
    int _0 = dec / _1e3, _1 = dec / _1e2 - _1e1 * _0, 
        _2 = dec / _1e1 -_1e2 * _0 -_1e1 * _1, 
        _3 = ((dec - _1e3 * _0) - _1e2 * _1) - _1e1 * _2;
    
    return int[](_0, _1, _2, _3); 
}

vec4 a_Vec4(int[4] ar) {
    return vec4(ar[0], ar[1], ar[2], ar[3]);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {   
    // Time varying pixel color
    vec3 col = vec3(0);
    
    
    //int resX = int(iResolution.y), 
    
    /*
    vec2 pix = vec2(iResolution.y - fragCoord.y, fragCoord.x);
    int xPix = int(pix.x), yPix = int(pix.y);
    */
        
    int dec = 0xF99F;   
    
    int[] pix = int[](int(iResolution.y - fragCoord.y), int(fragCoord.x)), 
        ar_Hex = a_Ar_Noton(dec, 16); //int[](0xf, 9, 9, 0xf) -> ar_Bin
        
    int[] _0 = a_Ar_Noton(ar_Hex[0], 2); //, _1, _2, _3; //ar_Bin, ar_Bin1...
    
    /*
    int[] _0 = separa_Decs(ar_Hex[0]), 
        _1 = separa_Decs(ar_Hex[1]), _2 = separa_Decs(ar_Hex[2]), 
        _3 = separa_Decs(ar_Hex[3]);  
    */
    
    
    
    //vec4 _v0 = a_Vec4(_0), _v1 = a_Vec4(_1), _v2 = a_Vec4(_2), _v3 = a_Vec4(_3);
    
    //mat4 m = mat4(_v0, _v1, _v2, _v3);
    
    //***** debug ******
    
    
    //if (_0 == int[](1,1,1,1))
    
    
    //if (ar_Hex == int[](0xf, 9, 9, 0xf))
    
    
    
    
    
    
    //int[] a = int[](1,2);
    
    
    
    ///*
    //if (pix[1] == 100) //if (yPix == 100)
    //if (pix[0] == 100) //if (xPix == 100) 
        col = vec3(1); 
    //*/
    

    // Output to screen
    fragColor = vec4(col,1.0);
}
