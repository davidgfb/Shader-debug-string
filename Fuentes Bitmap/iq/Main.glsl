const int font[] = int[](
 0x69f99, 0x79797, 0xe111e, 0x79997, 0xf171f, 0xf1711, 0xe1d96, 0x99f99, 
 0xf444f, 0x88996, 0x95159, 0x1111f, 0x9f999, 0x9bd99, 0x69996, 0x79971,
 0x69b5a, 0x79759, 0xe1687, 0xf4444, 0x99996, 0x999a4, 0x999f9, 0x99699,
 0x99e8e, 0xf843f, 0x6bd96, 0x46444, 0x6942f, 0x69496, 0x99f88, 0xf1687,
 0x61796, 0xf8421, 0x69696, 0x69e84, 0x66400, 0x0faa9, 0x0000f, 0x00600,
 0x0a500, 0x02720, 0x0f0f0, 0x08421, 0x33303, 0x69404, 0x00032, 0x00002,
 0x55000, 0x00000, 0x00202, 0x42224, 0x24442);

int CH_A = 0, CH_B = 1, CH_C = 2, CH_D = 3, CH_E = 4, CH_F = 5, CH_G = 6, CH_H = 7,
    CH_I = 8, CH_J = 9, CH_K = 10, CH_L = 11, CH_M = 12, CH_N = 13, CH_O = 14,
    CH_P = 15, CH_Q = 16, CH_R = 17, CH_S = 18, CH_T = 19, CH_U = 20, CH_V = 21,
    CH_W = 22, CH_X = 23, CH_Y = 24, CH_Z = 25, CH_0 = 26, CH_1 = 27, CH_2 = 28,
    CH_3 = 29, CH_4 = 30, CH_5 = 31, CH_6 = 32, CH_7 = 33, CH_8 = 34, CH_9 = 35,
    CH_APST = 36, CH_PI = 37, CH_UNDS = 38, CH_HYPH = 39, CH_TILD = 40, CH_PLUS = 41,
    CH_EQUL = 42, CH_SLSH = 43, CH_EXCL = 44, CH_QUES = 45, CH_COMM = 46, CH_FSTP = 47,
    CH_QUOT = 48, CH_BLNK = 49, CH_COLN = 50, CH_LPAR = 51, CH_RPAR = 52;

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
int drawInt( in int val, in vec2 pos, in vec2 size, in vec2 uv )
{
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
int drawFixed( in float val, in int places, in vec2 pos, in vec2 size, in vec2 uv )
{
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

int text( in vec2 uv, const float size )
{
    vec2 charSize = vec2( size*vec2(MAP_SIZE)/iResolution.y );
    float spaceSize = float( size*float(MAP_SIZE.x+1)/iResolution.y );
        
    // and a starting position.
    vec2 charPos = vec2(0.05, 0.90);
    // Draw some text!
    int chr = 0;
    // Bitmap text rendering!
    chr += drawChar( CH_B, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_I, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_M, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_A, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_P, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_BLNK, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_E, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_X, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_BLNK, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_R, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_E, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_N, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_D, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_E, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_R, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_I, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_N, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_G, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_EXCL, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_EXCL, charPos, charSize, uv); charPos.x += spaceSize;
    
    // Today's Date: {date}
    charPos = vec2(0.05, .75);
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_O, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_D, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_A, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_Y, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_APST, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_S, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_BLNK, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_D, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_A, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_E, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_BLNK, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_LPAR, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_M, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_M, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_HYPH, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_D, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_D, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_HYPH, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_Y, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_Y, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_Y, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_Y, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_RPAR, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_COLN, charPos, charSize, uv); charPos.x += .1;
    // The date itself.
    charPos.x += .3;
    chr += drawIntCarriage( int(iDate.x), charPos, charSize, uv, 4);
    chr += drawChar( CH_HYPH, charPos, charSize, uv); charPos.x-=spaceSize;
    chr += drawIntCarriage( int(iDate.z)+1, charPos, charSize, uv, 2);
    chr += drawChar( CH_HYPH, charPos, charSize, uv); charPos.x-=spaceSize;
    chr += drawIntCarriage( int(iDate.y)+1, charPos, charSize, uv, 2);
    
    // Shader uptime:
    charPos = vec2(0.05, .6);
    chr += drawChar( CH_I, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_G, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_L, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_O, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_B, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_A, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_L, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_T, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_I, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_M, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_E, charPos, charSize, uv); charPos.x += spaceSize;
    chr += drawChar( CH_COLN, charPos, charSize, uv); charPos.x += spaceSize;
    // The uptime itself.
    charPos.x += .3;
    chr += drawFixed( iTime, 2, charPos, charSize, uv);
    return chr;
}

/*
	Shadertoy's fancy entry function.
*/
void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Get Y-normalized UV coords.
	vec2 uv = fragCoord / iResolution.y;
    
    // Draw some text!
    float txt = float( text(uv, 3.5) );
    
	fragColor = vec4(txt,txt,txt,1.0);
}
