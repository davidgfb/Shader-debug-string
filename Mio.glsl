mat4 set_Fila(mat4 m, int n_Fila, int[4] ar_Int) { 
    for (int i = 0; i < 4; i++) {
        m[n_Fila][i] = float(ar_Int[i]);
    }
    
    return m;
}

int potia(int x, int y) {
    return int(pow(float(x), float(y)));
}

int[4] a_Ar_Noton(int dec, int base) {
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

void mainImage( out vec4 fragColor, vec2 fragCoord ) {
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x), dec = int(iTime); //0xF99F;    
    int[] ar_Hex = a_Ar_Noton(dec, 16), _0 = separa_Decs(ar_Hex[0]), 
        _1 = separa_Decs(ar_Hex[1]), _2 = separa_Decs(ar_Hex[2]), 
        _3 = separa_Decs(ar_Hex[3]);    
    
    mat4 m;
    
    m = set_Fila(m, 0, _0);
    m = set_Fila(m, 1, _1);
    m = set_Fila(m, 2, _2);
    m = set_Fila(m, 3, _3);

    vec3 col = vec3(0);
    
    if (xPix > 150 && xPix < 200 && yPix > 150 && yPix < 200) 
        col = vec3(m[xPix % 4][yPix % 4]);

    // Output to screen
    fragColor = vec4(col,1.0);
}
