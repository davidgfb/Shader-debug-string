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
 
/* 
//int a[] = int[](3, 4, 4, 2);
//int a = 0;

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
#define linea _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea1 _A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _M, _N, _O, _P, _Q, _R, _S, _T, _U, _V, _W, _X, _Y, _Z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea2 _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea3 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,  26, 27, 28, 29, 30, 31, 32,  59, 60, 61, 62, 63, 64,  91, 92, 93, 94, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1

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
    
    PRINT(linea3);    
    PRINT(linea2);       
    PRINT(linea1);   
    PRINT(linea);    
        
    fragColor.rgb = mix(vec3(fragCoord.x / iResolution.x * 0.5 + 0.5), Text.rgb, Text.a);
}
