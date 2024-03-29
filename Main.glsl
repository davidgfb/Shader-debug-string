int potia(int x, int y) {
    return int(pow(float(x), float(y)));
}

struct Byte {
    int[4] ar_Int; //xyzw, rgba
};

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

vec4 a_Vec4(Byte byte) {
    int[] ar_Int = byte.ar_Int;

    return vec4(ar_Int[0], ar_Int[1], ar_Int[2], ar_Int[3]);
}

struct V2 {
    int x, y; //int[2] ar_Int; 
};

void mainImage( out vec4 fragColor, in vec2 fragCoord ) {   
    // Time varying pixel color
    vec3 col = (vec3(0,0,1) + vec3(1,1,1)) / 4.0;
        
    //int resX = int(iResolution.y),     
    /*
    vec2 pix = vec2(iResolution.y - fragCoord.y, fragCoord.x);
    int xPix = int(pix.x), yPix = int(pix.y);
    */
    
    /*
    NO vale ponerlo en decimal. Hay q usar notacion '0xh' 
    0x1,0x1,0x1,0x1->1111d NO!->0x1111h (4369d) SÍ 
    */
    int t = int(iTime);
    int[] _0s = int[](0xF99F, 0x6996, 0x2552, 0x7557), 
        _1s = int[](0x1111, 0x3111, 0x1311, 0x6227, 0x2627),
        _As = int[](0xf9f9, 0x69f9, 0x7575, 0x2575),
        _bs = int[](0x8f9f, 0x4757), //minusculas! para mayus habria q ampliar dimensiones fila
        nums = int[](_0s[t % _0s.length()], _1s[t % _1s.length()]),
        letras = int[](_As[t % _As.length()], _bs[t % _bs.length()]),
        glifos = int[](_0s[t % _0s.length()], _1s[t % _1s.length()], 
            _As[t % _As.length()], _bs[t % _bs.length()]); 
    
    /*
    //unos[int(iTime) % unos.length()]; //nums[1]; //int(iTime) % nums.length()]; 
    //int(iTime) % 0xFFFF; //0xF99F; 
    //ceros[ceros.length() - 1];
    //ceros[int(iTime) % ceros.length()]; 
    */    
    int dec = glifos[t % glifos.length()]; //letras[t % letras.length()]; //_A[_A.length() - 1]; //t % _A.length()]; //nums[t % nums.length()]; 
    
    
    //int[](0xf, 9, 9, 0xf) -> ar_Bin
    
    //_0, _1, _2, _3 podrian ser bool[]
    V2 pix = V2(int(iResolution.y - fragCoord.y), int(fragCoord.x)); 
    
    int[] ar_Hex = a_Ar_Noton(dec, 16), _0 = a_Ar_Noton(ar_Hex[0], 2), 
        _1 = a_Ar_Noton(ar_Hex[1], 2), _2 = a_Ar_Noton(ar_Hex[2], 2), 
        _3 = a_Ar_Noton(ar_Hex[3], 2); //ar_Bin, ar_Bin1...
    
    /*
    int[] _0 = separa_Decs(ar_Hex[0]), 
        _1 = separa_Decs(ar_Hex[1]), _2 = separa_Decs(ar_Hex[2]), 
        _3 = separa_Decs(ar_Hex[3]);  
    */
        
    vec4[] v = vec4[](a_Vec4(Byte(_0)), a_Vec4(Byte(_1)), a_Vec4(Byte(_2)), 
        a_Vec4(Byte(_3)));
      
    //vec4 _v0 = a_Vec4(_0), _v1 = a_Vec4(_1), _v2 = a_Vec4(_2), _v3 = a_Vec4(_3);
    
    mat4 m = mat4(v[0], v[1], v[2], v[3]);
    
    //***** debug ******
    //if (_0 == int[](1,1,1,1))
    //if (ar_Hex == int[](0xf, 9, 9, 0xf))
    ///*
    
    //int xPix = pix.x, yPix = pix.y; 
    V2 rep = V2(100, 100), //prop, escala
        dims = V2(400, 400); //V2 rep = V2(100, 100); //100,50); 50, 50);
    //int tamagno = 100;
    
    if (pix.x < dims.x && pix.y < dims.y)
        col = vec3(m[pix.x / rep.x % (dims.x / 100)][pix.y / rep.y % 
            (dims.y / 100)]);
    
    //*/
    //int[] a = int[](1,2);   
    //if (_2 == int[](1,0,0,1)) //x q no?
    /*
    //if (pix[1] == 100) //if (yPix == 100)
    //if (pix[0] == 100) //if (xPix == 100) 
        col = vec3(1); 
    */    

    // Output to screen
    fragColor = vec4(col,1.0);
}
