/*
usa bool -> int/float?
*/

/*
mat4 set_Fila(mat4 m, int n_Fila, int[4] ar_Int) { 
    //hay mas formas de hacerlo inicializando otra matriz 
    //OJO parece q se puede inicializar x cols o filas
    for (int i = 0; i < 4; i++) m[n_Fila][i] = float(ar_Int[i]);
        
    return m;
}
*/

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

/*
float[4] a_Float(int[4] ar_Int) { //ar_Int_A_Ar_Float
    float[4] ar_Flt;
    
    for (int i = 0; i < 4; i++) ar_Flt[i] = float(ar_Int[i]);
    
    return ar_Flt;
}
*/

vec4 a_Vec4(int[4] ar) {
    return vec4(ar[0], ar[1], ar[2], ar[3]);
}

mat4 set_M(vec4 v) {
    return mat4(v, v, v, v);
}

mat4 rella_M(int dec) {    
    return set_M(vec4(dec));
}

mat4[16] set_M(int[256] ar) {
    mat4[16] m;
    
    //m[0], m[1], m[2], m[3], m[4], m[5]...
    for (int i = 0; i < 16; i++) m[i] = rella_M(i); //i=...

    return m;
}

/*
int[4] push(int[4] ar, int dec, int ult_Pos_Libre) {
    
    //ultimo elem de lista es la ult pos libre
    
    //ar[ar.length() - 1] = ult_Pos_Libre++;    
    ar[ult_Pos_Libre] = dec; //si fuera ultima pos sobrescribiria
    
    return ar;
}
*/

/* hay q especificar tamaño de ar1!! fuck
int[] push(int[256] ar, int[] ar1, int ult_Pos_Libre) {

    return int[];
}
*/

void mainImage( out vec4 fragColor, vec2 fragCoord ) {
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x), dec = 0xF99F; //dec = int(iTime) % 0xFFFF;     
    int[] ar_Hex = a_Ar_Noton(dec, 16), _0 = separa_Decs(ar_Hex[0]), 
        _1 = separa_Decs(ar_Hex[1]), _2 = separa_Decs(ar_Hex[2]), 
        _3 = separa_Decs(ar_Hex[3]);         
    vec4 _v0 = a_Vec4(_0), _v1 = a_Vec4(_1), _v2 = a_Vec4(_2), _v3 = a_Vec4(_3);    
                
    /*
    float[] _f0 = a_Float(_0), _f1 = a_Float(_1), _f2 = a_Float(_2), _f3 = a_Float(_3);  
    vec4 v = vec4(_0);
    vec4 v = vec4(_0[0], _0[1], _0[2], _0[3]);
    int[][](_0, _1, _2, _3);
    */
    
    mat4 m = mat4(_v0, _v1, _v2, _v3);     
    vec3 col = vec3(0);
        
    /*
    mejor dejamos 'clavado' en las decenas/centenas
    400x400, 400/4=4, 0: 0-99, 1: 100-199, 2: 200-299, 3: 300-399
    */    
    col = vec3(m[xPix / 4][yPix / 4]);
       
    /*
    int[] ar1 = int[](1, 2);
    //int[256] ar;       
    int[4] ar;
    int ult_Pos_Libre = 2, ar1_Tam = ar1.length(); 
        
    for (int i = 0; i < ar1_Tam && ar.length() - ult_Pos_Libre + 2 > ar1_Tam; 
        i++, ult_Pos_Libre++) //ar = push(ar, ar1[i], ult_Pos_Libre); //ar[ult_Pos_Libre] = ar1[i]; 
    */  
    /*
    //if (ar == int[](1,2,0,0))  //0
    //if (ar == int[](0, 1, 2, 0)) //1
    if (ar == int[](0,0, 1,2))  //2
    //3 NO CABE!!
        col = vec3(1);
    */
            
    /*2, 2<4-2=2, 2sig
    for (ult_Pos; ult_Pos < ar.length() - ar1.length(); ult_Pos++) { 
        //int pos = ar1.length(); //2
        
        //if (ult_Pos < pos) pos = 0; //1<2, ult_Pos
        
        //ar[ult_Pos] = ar1[ult_Pos - pos]; //
    }    
    */
   
    //mat4[16] m = mat4[]();
    
    /*
    int[4] a;
    int[] b = int[](0, 1);
    
    a = b;
    */
        
    //if (set_M(decs) == m) col = vec3(1);
    
    /********* m16 **********
    mat4 m = set_M4(_0), m1, m2, m3,
        m4, m5, m6, m7,
        m8, m9, m_A, m_B,
        m_C, m_D, m_E, m_F;
    */
        
    //int (1) -> mat4 (4^2 = 16), mat4 -> 16^2 = 256
    
    
    //if (xPix > 150 && xPix < 200 && yPix > 150 && yPix < 200) 
    //
    
    
    // Output to screen
    fragColor = vec4(col,1.0);
}
