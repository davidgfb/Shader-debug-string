#define STRLEN 50
#define String int[STRLEN]
vec4 Print(vec2 fragCoord, ivec2 LowerLeft, String Line)
{
    ivec2 Area = ivec2(STRLEN * 8, 8);
    ivec2 Pixel = ivec2(floor(fragCoord)) - LowerLeft;
    if (Pixel.x >= 0 && Pixel.y >= 0 && Pixel.x < Area.x && Pixel.y < Area.y)
    {
        int GlyphsPerRow = int(floor(iResolution.x)) / 8;
        int GlyphIndex = Line[Pixel.x / 8];
        if (GlyphIndex >= 0)
        {
        	ivec2 Glyph = ivec2(GlyphIndex % GlyphsPerRow, GlyphIndex / GlyphsPerRow);
			vec2 UV = vec2(0.5 + vec2(Glyph * 8 + (Pixel % 8))) / iResolution.xy;
        	return vec4(texture(iChannel0, UV).rgb, 1.0);
        }
    }
	return vec4(0.0);
}
 
 
//int a[] = int[](3, 4, 4, 2);

//int a = 0;
//#define text 1, 2, 3

/*
#define LINE_00 44, 79, 82, 69, 77, 0, 73, 80, 83, 85, 77, 0, 68, 79, 76, 79, 82, 0, 83, 73, 84, 0, 65, 77, 69, 84, 12, 0, 67, 79, 78, 83, 69, 67, 84, 69, 84, 85, 82, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_01 65, 68, 73, 80, 73, 83, 67, 73, 78, 71, 0, 69, 76, 73, 84, 12, 0, 83, 69, 68, 0, 68, 79, 0, 69, 73, 85, 83, 77, 79, 68, 0, 84, 69, 77, 80, 79, 82, 0, 73, 78, 67, 73, 68, 73, 68, 85, 78, 84, -1
#define LINE_02 85, 84, 0, 76, 65, 66, 79, 82, 69, 0, 69, 84, 0, 68, 79, 76, 79, 82, 69, 0, 77, 65, 71, 78, 65, 0, 65, 76, 73, 81, 85, 65, 14, 0, 53, 84, 0, 69, 78, 73, 77, 0, 65, 68, -1, -1, -1, -1, -1, -1
#define LINE_03 77, 73, 78, 73, 77, 0, 86, 69, 78, 73, 65, 77, 12, 0, 81, 85, 73, 83, 0, 78, 79, 83, 84, 82, 85, 68, 0, 69, 88, 69, 82, 67, 73, 84, 65, 84, 73, 79, 78, 0, 85, 76, 76, 65, 77, 67, 79, 0, -1, -1
#define LINE_04 76, 65, 66, 79, 82, 73, 83, 0, 78, 73, 83, 73, 0, 85, 84, 0, 65, 76, 73, 81, 85, 73, 80, 0, 69, 88, 0, 69, 65, 0, 67, 79, 77, 77, 79, 68, 79, 0, 67, 79, 78, 83, 69, 81, 85, 65, 84, 14, 0, -1
#define LINE_05 36, 85, 73, 83, 0, 65, 85, 84, 69, 0, 73, 82, 85, 82, 69, 0, 68, 79, 76, 79, 82, 0, 73, 78, 0, 82, 69, 80, 82, 69, 72, 69, 78, 68, 69, 82, 73, 84, 0, 73, 78, 0, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_06 86, 79, 76, 85, 80, 84, 65, 84, 69, 0, 86, 69, 76, 73, 84, 0, 69, 83, 83, 69, 0, 67, 73, 76, 76, 85, 77, 0, 68, 79, 76, 79, 82, 69, 0, 69, 85, 0, 70, 85, 71, 73, 65, 84, 0, -1, -1, -1, -1, -1
#define LINE_07 78, 85, 76, 76, 65, 0, 80, 65, 82, 73, 65, 84, 85, 82, 14, 0, 37, 88, 67, 69, 80, 84, 69, 85, 82, 0, 83, 73, 78, 84, 0, 79, 67, 67, 65, 69, 67, 65, 84, 0, 67, 85, 80, 73, 68, 65, 84, 65, 84, -1
#define LINE_08 78, 79, 78, 0, 80, 82, 79, 73, 68, 69, 78, 84, 12, 0, 83, 85, 78, 84, 0, 73, 78, 0, 67, 85, 76, 80, 65, 0, 81, 85, 73, 0, 79, 70, 70, 73, 67, 73, 65, 0, 68, 69, 83, 69, 82, 85, 78, 84, -1, -1
#define LINE_09 77, 79, 76, 76, 73, 84, 0, 65, 78, 73, 77, 0, 73, 68, 0, 69, 83, 84, 0, 76, 65, 66, 79, 82, 85, 77, 14, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_10 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_11 52, 72, 69, 0, 81, 85, 73, 67, 75, 0, 66, 82, 79, 87, 78, 0, 70, 79, 88, 0, 74, 85, 77, 80, 83, 0, 79, 86, 69, 82, 0, 84, 72, 69, 0, 76, 65, 90, 89, 0, 68, 79, 71, 14, -1, -1, -1, -1, -1, -1
#define LINE_12 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_13 17, 18, 19, 20, 21, 22, 23, 24, 25, 16, 59, 61, 1, 32, 3, 4, 5, 62, 6, 10, 8, 9, 91, 93, 11, 31, 29, 2, 28, 30, 29, 15, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define LINE_14 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
*/

#define LINE_15 33, 69, 86, 65, 0, 87, 65, 83, 0, 72, 69, 82, 69, 0, 62, 63, 62, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
/*
int LINE_14[50] = int[50](-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
*/

//tiene q tener 50 enteros x ancho max. Y si defino todos? _numeros = _0123456789
#define _0 16 
#define _1 17
#define _2 18
#define _3 19
#define _4 20
#define _5 21
#define _6 22
#define _7 23
#define _8 24
#define _9 25
#define _A 33 
#define _B 34
#define _C 35
#define _D 36 
#define _E 37
#define _F 38
#define _G 39 
#define _H 40
#define _I 41
#define _J 42 
#define _K 43
#define _L 44
#define _M 45 
#define _N 46
#define _O 47
#define _P 48
#define _Q 49
#define _R 50
#define _S 51
#define _T 52
#define _U 53
#define _V 54
#define _W 55
#define _X 56
#define _Y 57
#define _Z 58
#define _a 65
#define _b 66
#define _c 67
#define _d 68
#define _e 69
#define _f 70
#define _g 71
#define _h 72
#define _i 73
#define _j 74
#define _k 75
#define _l 76
#define _m 77
#define _n 78
#define _o 79
#define _p 80
#define _q 81
#define _r 82
#define _s 83
#define _t 84
#define _u 85
#define _v 86
#define _w 87
#define _x 88
#define _y 89
#define _z 90

/*
a partir de numeros altos se repite:
0-11 = 100-111, 0-4 = 95-99
*/
#define linea _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, _A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _M, _N, _O, _P, _Q, _R, _S, _T, _U, _V, _W, _X, _Y, _Z, _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n
#define linea1 _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea2 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,  26, 27, 28, 29, 30, 31, 32,  59, 60, 61, 62, 63, 64,  91, 92, 93, 94, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1

//#define linea1 _R, _S, _T, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, 26, 27, 28, 29, 30, 31, 32, _A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _M, _N, _O, _P, _Q


#define PRINT(LINE) Text += Print(fragCoord / Scale, ivec2(0, (Cursor++) * 8), String(LINE));

/*
void once() {
    int LINE_14_1[50] = LINE_14;

    for (int i = 0; i < 50; i++) {
        LINE_14_1(i) = -1;
    }
}
*/

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{  
    float SlugWidth = float(STRLEN) * 8.0;
    float Scale = max(round(iResolution.x / SlugWidth), 1.0);
       
    int Cursor = 1;
    vec4 Text = vec4(0.0);
    
    //PRINT(text);
    
    PRINT(linea2);
    PRINT(linea1);
    PRINT(linea);
    
    /*
    PRINT(LINE_14);
    PRINT(LINE_13);
    PRINT(LINE_12);
    PRINT(LINE_11);
    PRINT(LINE_10);
    PRINT(LINE_09);
    PRINT(LINE_08);
    PRINT(LINE_07);
    PRINT(LINE_06);
    PRINT(LINE_05);
    PRINT(LINE_04);
    PRINT(LINE_03);
    PRINT(LINE_02);
    PRINT(LINE_01);
    
    
    PRINT(LINE_00);
    */
    
    fragColor.rgb = mix(vec3(fragCoord.x / iResolution.x * 0.5 + 0.5), Text.rgb, Text.a);
}
