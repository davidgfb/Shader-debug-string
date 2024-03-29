const int font[] = int[](
 0x69f99, 0x79797, 0xe111e, 0x79997, 0xf171f, 0xf1711, 0xe1d96, 0x99f99, 
 0xf444f, 0x88996, 0x95159, 0x1111f, 0x9f999, 0x9bd99, 0x69996, 0x79971,
 0x69b5a, 0x79759, 0xe1687, 0xf4444, 0x99996, 0x999a4, 0x999f9, 0x99699,
 0x99e8e, 0xf843f, 0x6bd96, 0x46444, 0x6942f, 0x69496, 0x99f88, 0xf1687,
 0x61796, 0xf8421, 0x69696, 0x69e84, 0x66400, 0x0faa9, 0x0000f, 0x00600,
 0x0a500, 0x02720, 0x0f0f0, 0x08421, 0x33303, 0x69404, 0x00032, 0x00002,
 0x55000, 0x00000, 0x00202, 0x42224, 0x24442);

#define CH_A 0
#define CH_B 1
#define CH_C 2
#define CH_D 3
#define CH_E 4
#define CH_F 5
#define CH_G 6
#define CH_H 7
#define CH_I 8
#define CH_J 9
#define CH_K 10
#define CH_L 11
#define CH_M 12
#define CH_N 13
#define CH_O 14
#define CH_P 15
#define CH_Q 16
#define CH_R 17
#define CH_S 18
#define CH_T 19
#define CH_U 20
#define CH_V 21
#define CH_W 22
#define CH_X 23
#define CH_Y 24
#define CH_Z 25
#define CH_0 26
#define CH_1 27
#define CH_2 28
#define CH_3 29
#define CH_4 30
#define CH_5 31
#define CH_6 32
#define CH_7 33
#define CH_8 34
#define CH_9 35
#define CH_APST 36
#define CH_PI   37
#define CH_UNDS 38
#define CH_HYPH 39
#define CH_TILD 40
#define CH_PLUS 41
#define CH_EQUL 42
#define CH_SLSH 43
#define CH_EXCL 44
#define CH_QUES 45
#define CH_COMM 46
#define CH_FSTP 47
#define CH_QUOT 48 
#define CH_BLNK 49
#define CH_COLN 50
#define CH_LPAR 51
#define CH_RPAR 52

const ivec2 MAP_SIZE = ivec2(4,5);

/*
	Draws a character, given its encoded value, a position, size and
	current [0..1] uv coordinate.
*/
int drawChar( in int char, in vec2 pos, in vec2 size, in vec2 uv )
{
    
    // Subtract our position from the current uv so that we can
    // know if we're inside the bounding box or not.
    uv-=pos;
    
    // Divide the screen space by the size, so our bounding box is 1x1.
    uv /= size;    
    
    // Multiply the UV by the bitmap size so we can work in
    // bitmap space coordinates.
    uv *= vec2(MAP_SIZE);

    // Compute bitmap texel coordinates
    ivec2 iuv = ivec2(round(uv));
    
	// Bounding box check. With branches, so we avoid the maths and lookups    
    if( iuv.x<0 || iuv.x>MAP_SIZE.x-1 ||
        iuv.y<0 || iuv.y>MAP_SIZE.y-1 ) return 0;

    // Compute bit index
    int index = MAP_SIZE.x*iuv.y + iuv.x;
    
    // Get the appropriate bit and return it.
    return (font[char]>>index)&1;

}

/*
	Prints a float as an int. Be very careful about overflow.
	This as a side effect will modify the character position,
	so that multiple calls to this can be made without worrying
	much about kerning.
*/
int drawIntCarriage( in int val, inout vec2 pos, in vec2 size, in vec2 uv, in int places )
{
    // Create a place to store the current values.
    int res = 0;
    // Surely it won't be more than 10 chars long, will it?
    // (MAX_INT is 10 characters)
    for( int i = 0; i < 10; ++i )
    {
        // If we've run out of film, cut!
        if(val == 0 && i >= places) break;
        // The current lsd is the difference between the current
        // value and the value rounded down one place.
        int digit = val % 10;
        // Draw the character. Since there are no overlaps, we don't
        // need max().
        res |= drawChar(CH_0+digit,pos,size,uv);
        // Move the carriage.
        pos.x -= size.x*1.2;
        // Truncate away this most recent digit.
        val /= 10;
    }
    return res;
}

/*
	Draws an integer to the screen. No side-effects, but be ever vigilant
	so that your cup not overfloweth.
*/
int drawInt( in int val, in vec2 pos, in vec2 size, in vec2 uv ) {
    vec2 p = vec2(pos);
    float s = sign(float(val));
    val *= int(s);
    
    int c = drawIntCarriage(val,p,size,uv,1);
    if( s<0.0 ) c |= drawChar(CH_HYPH,p,size,uv);
    return c;
}

/*
	Prints a fixed point fractional value. Be even more careful about overflowing.
*/
int drawFixed( in float val, in int places, in vec2 pos, in vec2 size, in vec2 uv ) {
    float fval, ival;
    fval = modf(val, ival);
    
    vec2 p = vec2(pos);
    
    // Draw the floating point part.
    int res = drawIntCarriage( int( fval*pow(10.0,float(places)) ), p, size, uv, places );
    // The decimal is tiny, so we back things up a bit before drawing it.
    p.x += size.x*.4;
    res |= drawChar(CH_FSTP,p,size,uv); p.x-=size.x*1.2;
    // And after as well.
    p.x += size.x *.1;
    // Draw the integer part.
    res |= drawIntCarriage(int(ival),p,size,uv,1);
	return res;
}

/*
int dec_A_Bin(int dec) {
    return bin;
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

int dec_A_Noton(int dec, int base) {
    /*
    int, int -> int
    USO: int dec_A_Bin = dec_A_Noton(dec, 2), dec_A_Hex(dec, 16);
    */
    int[] ar_Noton = a_Ar_Noton(dec, base);   
    int _0 = ar_Noton[0], _1 = ar_Noton[1], _2 = ar_Noton[2], _3 = ar_Noton[3], 
        noton = 0;
    
    //binario
    if (base == 2) noton = _1e3 * _0 + _1e2 * _1 + _1e1 * _2 + _3;
        
    //hexadecimal, notacion NO se reusa
    else if (base == 16) noton = int(1e12) * _0 + int(1e8) * _1 + int(1e4) * _2 + _3;
    
    return noton;
}

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
int dec_A_Bin(int dec) {
    
    PRE: n < 5, n € Z
    
    int _3 = dec % 2, _2 = dec / 2 % 2, _1 = dec / //int(pow(2.0, 2.0)) % 2, 
        _0 = dec / int(pow(2.0, 3.0)) % 2; 
        
    
    int[] ar_Bin = int[](_0, _1, _2, _3); 
    int nElems = ar_Bin.length(), 
    
        
    return int(1e3) * _0 + int(1e2) * _1 + 10 * _2 + _3;
}
*/

/*
void impr_Hex(int dec) {
    //10 = A, 11 = B, 12 = C, 13 = D, 14 = E
    if (dec > 9 && dec < 15) letras[n + offset];
}
*/

// and a starting position.
vec2 charPos = vec2(0.05, 0.90);

/*
	Shadertoy's fancy entry function.
*/
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    vec3 col = vec3(0);

    // Get Y-normalized UV coords.
	vec2 uv = fragCoord / iResolution.y;
        
    float size = 3.5;
       
    vec2 charSize = vec2( size*vec2(MAP_SIZE)/iResolution.y );
    float spaceSize = float( size*float(MAP_SIZE.x+1)/iResolution.y );
        
    
    // Draw some text!
    int chr = 0;
    
    //1e3 == 1*10^3 = 1000, 10e3 = 10*10^3 = 10 000!!
    int dec = 0xF99F;
    
    int[] ar_Hex = a_Ar_Noton(dec, 16);
    int _0 = ar_Hex[0], _1 = ar_Hex[1], _2 = ar_Hex[2], _3 = ar_Hex[3];
    
    //int hex = int(1e12) * _0 + int(1e8) * _1 + int(1e4) * _2 + _3;    
    charPos = vec2(0.2, 0.8);  
    
    chr += drawIntCarriage( dec, charPos, charSize, uv, 4); 
    charPos.x += 0.25;

    chr += drawChar( CH_D, charPos, charSize, uv); 
    charPos.x += 0.05;
    
    /*
    chr += drawChar( CH_E, charPos, charSize, uv); pos += pow(20.0, -1.0); charPos = vec2(pos, 0.8);
    chr += drawChar( CH_C, charPos, charSize, uv); pos += pow(20.0, -1.0); charPos = vec2(pos, 0.8);
    */
    
    chr += drawChar( CH_EQUL, charPos, charSize, uv); 
    charPos.x += 0.2;

    chr += drawIntCarriage( _0, charPos, charSize, uv, 4); 
    charPos.x += 1.0 / 3.0; 
    chr += drawIntCarriage( _1, charPos, charSize, uv, 4); 
    charPos.x += 1.0 / 3.0;
    chr += drawIntCarriage( _2, charPos, charSize, uv, 4); 
    charPos.x += 1.0 / 3.0;
    chr += drawIntCarriage( _3, charPos, charSize, uv, 4); 
    charPos.x += 0.2;

    //chr += drawIntCarriage( hex, charPos, charSize, uv, 4); pos += pow(20.0, -1.0); charPos = vec2(pos, 0.8);

    chr += drawChar( CH_H, charPos, charSize, uv); 
    charPos.x += 0.05;
    chr += drawChar( CH_EQUL, charPos, charSize, uv); 
    charPos.x += 1.0 / 3.0;

    _0 = dec_A_Noton(_0, 2), _1 = dec_A_Noton(_1, 2), _2 = dec_A_Noton(_2, 2), 
    _3 = dec_A_Noton(_3, 2);
      
    charPos = vec2(0.1, 0.6);   
    
    chr += drawChar( CH_EQUL, charPos, charSize, uv); charPos.x += 0.2;
   
    chr += drawIntCarriage( _0, charPos, charSize, uv, 4); charPos.x += 1.0 / 3.0;    
    chr += drawIntCarriage( _1, charPos, charSize, uv, 4); charPos.x += 1.0 / 3.0;
    chr += drawIntCarriage( _2, charPos, charSize, uv, 4); charPos.x += 1.0 / 3.0;
    chr += drawIntCarriage( _3, charPos, charSize, uv, 4); charPos.x += 0.2;
   
    chr += drawChar( CH_B, charPos, charSize, uv); 
 
    //division entera
    /*
    //int dec = 1, 
    _3 = dec % 2, _2 = dec / 2 % 2, _1 = dec / int(pow(2.0, 2.0)) % 2, 
        _0 = dec / int(pow(2.0, 3.0)) % 2; 
    int[] ar_Bin = int[](_0, _1, _2, _3); 
    int nElems = ar_Bin.length(), bin = int(1e3) * _0 + int(1e2) * _1 + 10 * _2 + _3;
    */
      
    /*
    chr += drawChar( CH_EQUL, charPos, charSize, uv); pos += pow(6.0, -1.0); charPos = vec2(pos, 0.8);
    
    chr += drawIntCarriage( bin, charPos, charSize, uv, 4); pos += pow(20.0, -1.0); charPos = vec2(pos, 0.8);

    chr += drawChar( CH_B, charPos, charSize, uv); pos += pow(20.0, -1.0); charPos = vec2(pos, 0.8);
    */
        
    // Draw some text!    
	fragColor = vec4(vec3(chr), 1.0); 
}
