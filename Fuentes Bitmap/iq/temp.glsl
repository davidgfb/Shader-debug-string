const int _A = 0x69f99, _B = 0x79797, _C = 0xe111e, _D = 0x79997, 
    _E = 0xf171f, _F = 0xf1711, _G = 0xe1d96, _H = 0x99f99, _I = 0xf444f, 
    _J = 0x88996, _K = 0x95159, _L = 0x1111f, _M = 0x9f999, _N = 0x9bd99, 
    _O = 0x69996, _P = 0x79971, _Q = 0x69b5a, _R = 0x79759, _S = 0xe1687, 
    _T = 0xf4444, _U = 0x99996, _V = 0x999a4, _W = 0x999f9, _X = 0x99699, 
    _Y = 0x99e8e, _Z = 0xf843f, _0 = 0x6bd96, _1 = 0x46444, _2 = 0x6942f, 
    _3 = 0x69496, _4 = 0x99f88, _5 = 0xf1687, _6 = 0x61796, _7 = 0xf8421, 
    _8 = 0x69696, _9 = 0x69e84, _APST = 0x66400, _PI = 0x0faa9, 
    _UNDS = 0x0000f, _HYPH = 0x00600, _TILD = 0x0a500, _PLUS = 0x02720, 
    _EQUL = 0x0f0f0, _SLSH = 0x08421, _EXCL = 0x33303, _QUES = 0x69404, 
    _COMM = 0x00032, _FSTP = 0x00002, _QUOT = 0x55000, _BLNK = 0x00000, 
    _COLN = 0x00202, _LPAR = 0x42224, _RPAR = 0x24442;
    
int[10] digitos = int[10](_0, _1, _2, _3, _4, _5, _6, _7, _8, _9);

const ivec2 MAP_SIZE = ivec2(4,5);

vec2 charPos = vec2(0.05, 0.90);
float spaceSize = 0.0;

vec2 charSize, uv;

/*
	Draws a character, given its encoded value, a position, size and
	current [0..1] uv coordinate.
*/
int drawChar(int char) {
    int salida = 0;
    
    // Subtract our position from the current uv so that we can
    // know if we're inside the bounding box or not.
    uv -= charPos;
    
    // Divide the screen space by the size, so our bounding box is 1x1.
    uv /= charSize;    
    
    // Multiply the UV by the bitmap size so we can work in
    // bitmap space coordinates.
    uv *= vec2(MAP_SIZE);

    // Compute bitmap texel coordinates
    ivec2 iuv = ivec2(round(uv));
    
	// Bounding box check. With branches, so we avoid the maths and lookups    
    if(!(iuv.x < 0 || iuv.x > MAP_SIZE.x - 1 || iuv.y < 0 || iuv.y > MAP_SIZE.y - 1)) {               
        // Compute bit index
        int index = MAP_SIZE.x * iuv.y + iuv.x;

        // Get the appropriate bit and return it.
        salida = (char >> index) & 1;
    }
    
    charPos.x += spaceSize;
    
    return salida;
}

/*
	Prints a float as an int. Be very careful about overflow.
	This as a side effect will modify the character position,
	so that multiple calls to this can be made without worrying
	much about kerning.
*/
int drawIntCarriage(int val, int places) {
    // Create a place to store the current values.
    int res = 0;
    
    // Surely it won't be more than 10 chars long, will it?
    // (MAX_INT is 10 characters)
    for (int i = 0; i < 10; ++i) {
        // If we've run out of film, cut!
        if (val == 0 && i >= places) i = 10;
        
        else {
            // The current lsd is the difference between the current
            // value and the value rounded down one place.
            int digit = val % 10;
            // Draw the character. Since there are no overlaps, we don't
            // need max().
            res |= drawChar(digitos[digit]); //, pos, size, uv); 
            // Move the carriage.
            charPos.x -= charSize.x * 1.2;
            // Truncate away this most recent digit.
            val /= 10;
        }
    }
    
    return res;
}

/*
	Draws an integer to the screen. No side-effects, but be ever vigilant
	so that your cup not overfloweth.
*/
int drawInt(int val, vec2 pos, vec2 size, vec2 uv) {
    vec2 p = vec2(pos);
    float s = sign(float(val));
    
    val *= int(s);
    
    int c = drawIntCarriage(val, 1);
    
    if (s < 0.0) c |= drawChar(_HYPH);
    
    return c;
}

/*
	Prints a fixed point fractional value. Be even more careful about overflowing.
*/
int drawFixed(float val, int places) {
    float ival = 0.0, fval = modf(val, ival);
    
    // Draw the floating point part.
    int res = drawIntCarriage(int(fval * pow(10.0, float(places))), places);
    // The decimal is tiny, so we back things up a bit before drawing it.
    charPos.x += charSize.x * 0.4;
    res |= drawChar(_FSTP); charPos.x -= charSize.x * 1.2;
    // And after as well.
    charPos.x += charSize.x / 10.0;
    // Draw the integer part.
    res |= drawIntCarriage(int(ival), 1);
	
    return res;
}

int drawChar(int[50] chars) {
    int suma = 0;
    
    for (int i = 0; i < 50; i++) suma += drawChar(chars[i]);
       
    return suma;
}

/*
int drawIntCarriage(int val, int places) {
    //int res = 0; //para iterativa
    
    return drawIntCarriage(val, places); //res; //idem
}
*/

int text(vec2 uv, const float size) {
    float inter = size / iResolution.y;
    
    charSize = vec2(inter * vec2(MAP_SIZE));
    spaceSize = float(inter * float(MAP_SIZE.x + 1));
    // and a starting position.
    // Draw some text!
    int chr = 0;
    
    // Bitmap text rendering!       
    int[] text = int[](_B, _I, _T, _M, _A, _P, _BLNK, _T, _E, _X,
        _T, _BLNK, _R, _E, _N, _D, _E, _R, _I, _N, _G, _EXCL,
        _EXCL); 
    const int n = text.length();   
    int[50] plantilla, plantilla1 = plantilla, plantilla2 = plantilla;    

    for (int i = 0; i < n; i++) {
        plantilla1[i] = text[i];
    }
        
    chr += drawChar(plantilla1); 
    
    // Today's Date: {date}
    charPos = vec2(0.05, 0.75); //!
    
    int[] text1 = int[](_T, _O, _D, _A, _Y, _APST, _S, _BLNK, _D, _A, _T, _E, _BLNK, 
        _LPAR, _M, _M, _HYPH, _D, _D, _HYPH, _Y, _Y, _Y, _Y, _RPAR, _COLN);
    //int[] text1 = int[](_T);
    
    const int n1 = text1.length();
    
    for (int i = 0; i < n1; i++) {
        plantilla2[i] = text1[i];
    }
        
    //conflige en la misma linea
    //chr += drawChar(plantilla2); //50 espacios negros tapan la sig linea en la misma pos
    
    charPos.x -= spaceSize; //
    charPos.x += 0.1;
    
    // The date itself.
    charPos.x += 0.3;
    chr += drawIntCarriage( int(iDate.x), 4);
    
    chr += drawChar( _HYPH); 
    charPos.x -= spaceSize; //
    charPos.x -= spaceSize;
    
    chr += drawIntCarriage( int(iDate.z) + 1, 2);
    
    chr += drawChar( _HYPH); 
    charPos.x -= spaceSize; //
    charPos.x -= spaceSize;
    
    chr += drawIntCarriage( int(iDate.y) + 1, 2);
    
    // Shader uptime:
    charPos = vec2(0.05, 0.6);
    
    int[] text2 = int[](_I, _G, _L, _O, _B, _A, _L, _T, _I, _M, _E, _COLN);
     
    // The uptime itself.
    charPos.x += 0.3;
    chr += drawFixed( iTime, 2);
    
    return chr;
}

/*
	Shadertoy's fancy entry function.
*/
void mainImage(out vec4 fragColor, vec2 fragCoord) {
    // Get Y-normalized UV coords.
	uv = fragCoord / iResolution.y;
    
    float size = 3.5;
    
    // Draw some text!
    float txt = float(text(uv, size));
        
	fragColor = vec4(vec3(txt), 1.0);
}
