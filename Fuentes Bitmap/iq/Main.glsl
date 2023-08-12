const int CH_A = 0x69f99, CH_B = 0x79797, CH_C = 0xe111e, CH_D = 0x79997, 
    CH_E = 0xf171f, CH_F = 0xf1711, CH_G = 0xe1d96, CH_H = 0x99f99, CH_I = 0xf444f, 
    CH_J = 0x88996, CH_K = 0x95159, CH_L = 0x1111f, CH_M = 0x9f999, CH_N = 0x9bd99, 
    CH_O = 0x69996, CH_P = 0x79971, CH_Q = 0x69b5a, CH_R = 0x79759, CH_S = 0xe1687, 
    CH_T = 0xf4444, CH_U = 0x99996, CH_V = 0x999a4, CH_W = 0x999f9, CH_X = 0x99699, 
    CH_Y = 0x99e8e, CH_Z = 0xf843f, CH_0 = 0x6bd96, CH_1 = 0x46444, CH_2 = 0x6942f, 
    CH_3 = 0x69496, CH_4 = 0x99f88, CH_5 = 0xf1687, CH_6 = 0x61796, CH_7 = 0xf8421, 
    CH_8 = 0x69696, CH_9 = 0x69e84, CH_APST = 0x66400, CH_PI = 0x0faa9, 
    CH_UNDS = 0x0000f, CH_HYPH = 0x00600, CH_TILD = 0x0a500, CH_PLUS = 0x02720, 
    CH_EQUL = 0x0f0f0, CH_SLSH = 0x08421, CH_EXCL = 0x33303, CH_QUES = 0x69404, 
    CH_COMM = 0x00032, CH_FSTP = 0x00002, CH_QUOT = 0x55000, CH_BLNK = 0x00000, 
    CH_COLN = 0x00202, CH_LPAR = 0x42224, CH_RPAR = 0x24442;
    
int[10] digitos = int[10](CH_0, CH_1, CH_2, CH_3, CH_4, CH_5, CH_6, CH_7, CH_8, CH_9);

const ivec2 MAP_SIZE = ivec2(4,5);

vec2 charPos = vec2(0.05, 0.90);
float spaceSize = 0.0;

/*
	Draws a character, given its encoded value, a position, size and
	current [0..1] uv coordinate.
*/
int drawChar(int char, vec2 pos, vec2 size, vec2 uv) {
    int salida = 0;
    
    // Subtract our position from the current uv so that we can
    // know if we're inside the bounding box or not.
    uv -= pos;
    
    // Divide the screen space by the size, so our bounding box is 1x1.
    uv /= size;    
    
    // Multiply the UV by the bitmap size so we can work in
    // bitmap space coordinates.
    uv *= vec2(MAP_SIZE);

    // Compute bitmap texel coordinates
    ivec2 iuv = ivec2(round(uv));
    
	// Bounding box check. With branches, so we avoid the maths and lookups    
    if(!(iuv.x < 0 || iuv.x > MAP_SIZE.x - 1 || iuv.y < 0 || iuv.y > MAP_SIZE.y - 1)) {               
        // Compute bit index
        int index = MAP_SIZE.x*iuv.y + iuv.x;

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
int drawIntCarriage(int val, out vec2 pos, vec2 size, vec2 uv, int places) {
    // Create a place to store the current values.
    int res = 0;
    // Surely it won't be more than 10 chars long, will it?
    // (MAX_INT is 10 characters)
    for (int i = 0; i < 10; ++i) {
        // If we've run out of film, cut!
        if (val == 0 && i >= places) {
            i = 10;
        
        } else {
            // The current lsd is the difference between the current
            // value and the value rounded down one place.
            int digit = val % 10;
            // Draw the character. Since there are no overlaps, we don't
            // need max().
            res |= drawChar(digitos[digit], pos, size, uv); //CH_0 = 26
            // Move the carriage.
            pos.x -= size.x * 1.2;
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
    
    int c = drawIntCarriage(val, p, size, uv, 1);
    
    if (s < 0.0) c |= drawChar(CH_HYPH, p, size, uv);
    
    return c;
}

/*
	Prints a fixed point fractional value. Be even more careful about overflowing.
*/
int drawFixed(float val, int places, vec2 pos, vec2 size, vec2 uv) {
    float ival = 0.0, fval = modf(val, ival);
    
    vec2 p = vec2(pos);
    
    // Draw the floating point part.
    int res = drawIntCarriage(int(fval * pow(10.0, float(places))), p, size, uv, places);
    // The decimal is tiny, so we back things up a bit before drawing it.
    p.x += size.x * 0.4;
    res |= drawChar(CH_FSTP, p, size, uv); p.x -= size.x * 1.2;
    // And after as well.
    p.x += size.x / 10.0;
    // Draw the integer part.
    res |= drawIntCarriage(int(ival), p, size, uv, 1);
	
    return res;
}

vec2 charSize, UV;

int drawChar(int char) {
    return drawChar(char, charPos, charSize, UV);
}

int text(vec2 uv, const float size) {
    charSize = vec2(size * vec2(MAP_SIZE) / iResolution.y);
    spaceSize = float(size * float(MAP_SIZE.x + 1) / iResolution.y);
    UV = uv;    
    // and a starting position.
    //vec2 charPos = vec2(0.05, 0.90);
    // Draw some text!
    int chr = 0;
    
    // Bitmap text rendering!
    chr += drawChar( CH_B); 
    chr += drawChar( CH_I); 
    chr += drawChar( CH_T); 
    chr += drawChar( CH_M); 
    chr += drawChar( CH_A); 
    chr += drawChar( CH_P); 
    chr += drawChar( CH_BLNK); 
    chr += drawChar( CH_T); 
    chr += drawChar( CH_E); 
    chr += drawChar( CH_X); 
    chr += drawChar( CH_T); 
    chr += drawChar( CH_BLNK); 
    chr += drawChar( CH_R); 
    chr += drawChar( CH_E); 
    chr += drawChar( CH_N); 
    chr += drawChar( CH_D); 
    chr += drawChar( CH_E); 
    chr += drawChar( CH_R); 
    chr += drawChar( CH_I); 
    chr += drawChar( CH_N); 
    chr += drawChar( CH_G); 
    chr += drawChar( CH_EXCL); 
    chr += drawChar( CH_EXCL); 
    
    // Today's Date: {date}
    charPos = vec2(0.05, 0.75);
    
    chr += drawChar( CH_T);
    chr += drawChar( CH_O); 
    chr += drawChar( CH_D); 
    chr += drawChar( CH_A); 
    chr += drawChar( CH_Y); 
    chr += drawChar( CH_APST); 
    chr += drawChar( CH_S); 
    chr += drawChar( CH_BLNK); 
    chr += drawChar( CH_D); 
    chr += drawChar( CH_A);
    chr += drawChar( CH_T); 
    chr += drawChar( CH_E); 
    chr += drawChar( CH_BLNK); 
    chr += drawChar( CH_LPAR); 
    chr += drawChar( CH_M); 
    chr += drawChar( CH_M); 
    chr += drawChar( CH_HYPH); 
    chr += drawChar( CH_D); 
    chr += drawChar( CH_D); 
    chr += drawChar( CH_HYPH); 
    chr += drawChar( CH_Y); 
    chr += drawChar( CH_Y);
    chr += drawChar( CH_Y); 
    chr += drawChar( CH_Y); 
    chr += drawChar( CH_RPAR); 
    
    chr += drawChar( CH_COLN); 
    charPos.x -= spaceSize; //
    charPos.x += 0.1;
    
    // The date itself.
    charPos.x += 0.3;
    chr += drawIntCarriage( int(iDate.x), charPos, charSize, uv, 4);
    
    chr += drawChar( CH_HYPH); 
    charPos.x -= spaceSize; //
    charPos.x-=spaceSize;
    
    chr += drawIntCarriage( int(iDate.z) + 1, charPos, charSize, uv, 2);
    
    chr += drawChar( CH_HYPH); 
    charPos.x -= spaceSize; //
    charPos.x-=spaceSize;
    
    chr += drawIntCarriage( int(iDate.y) + 1, charPos, charSize, uv, 2);
    
    // Shader uptime:
    charPos = vec2(0.05, 0.6);
    
    chr += drawChar( CH_I);
    chr += drawChar( CH_G);
    chr += drawChar( CH_L); 
    chr += drawChar( CH_O); 
    chr += drawChar( CH_B); 
    chr += drawChar( CH_A);
    chr += drawChar( CH_L);
    chr += drawChar( CH_T); 
    chr += drawChar( CH_I); 
    chr += drawChar( CH_M);
    chr += drawChar( CH_E); 
    chr += drawChar( CH_COLN); 
    
    // The uptime itself.
    charPos.x += 0.3;
    chr += drawFixed( iTime, 2, charPos, charSize, uv);
    
    return chr;
}

/*
	Shadertoy's fancy entry function.
*/
void mainImage(out vec4 fragColor, vec2 fragCoord) {
    // Get Y-normalized UV coords.
	vec2 uv = fragCoord / iResolution.y;
    
    // Draw some text!
    float txt = float(text(uv, 3.5));
        
	fragColor = vec4(vec3(txt), 1.0);
}
