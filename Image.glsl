#define STRLEN 50
#define String int[STRLEN]

vec4 Print(vec2 fragCoord, ivec2 LowerLeft, String Line) {
    ivec2 Area = ivec2(STRLEN * 8, 8);
    ivec2 Pixel = ivec2(floor(fragCoord)) - LowerLeft;
    
    if (Pixel.x >= 0 && Pixel.y >= 0 && Pixel.x < Area.x && Pixel.y < Area.y) {
        int GlyphsPerRow = int(floor(iResolution.x)) / 8;
        int GlyphIndex = Line[Pixel.x / 8];
        
        if (GlyphIndex >= 0) {
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
*/

//tiene q tener 50 enteros x STRLEN. Y si defino todos? _numeros = _0123456789
int _0 = 16; 
int _1 = 17;
int _2 = 18;
int _3 = 19;
int _4 = 20;
int _5 = 21;
int _6 = 22;
int _7 = 23;
int _8 = 24;
int _9 = 25;
int _A = 33; 
int _B = 34;
int _C = 35;
int _D = 36; 
int _E = 37;
int _F = 38;
int _G = 39; 
int _H = 40;
int _I = 41;
int _J = 42; 
int _K = 43;
int _L = 44;
int _M = 45; 
int _N = 46;
int _O = 47;
int _P = 48;
int _Q = 49;
int _R = 50;
int _S = 51;
int _T = 52;
int _U = 53;
int _V = 54;
int _W = 55;
int _X = 56;
int _Y = 57;
int _Z = 58;
int _a = 65;
int _b = 66;
int _c = 67;
int _d = 68;
int _e = 69;
int _f = 70;
int _g = 71;
int _h = 72;
int _i = 73;
int _j = 74;
int _k = 75;
int _l = 76;
int _m = 77;
int _n = 78;
int _o = 79;
int _p = 80;
int _q = 81;
int _r = 82;
int _s = 83;
int _t = 84;
int _u = 85;
int _v = 86;
int _w = 87;
int _x = 88;
int _y = 89;
int _z = 90;

/*
a partir de numeros altos se repite:
0-11 = 100-111, 0-4 = 95-99
#define linea _0, _1, _2, _3, _4, _5, _6, _7, _8, _9, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea1 _A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _M, _N, _O, _P, _Q, _R, _S, _T, _U, _V, _W, _X, _Y, _Z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea2 _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
#define linea3 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,  26, 27, 28, 29, 30, 31, 32,  59, 60, 61, 62, 63, 64,  91, 92, 93, 94, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1
*/

//string convierte define a array de int
#define PRINT(LINE) Text += Print(fragCoord / Scale, ivec2(0, 8 * Cursor++), LINE);

/*
void once() {
    int LINE_14_1[50] = LINE_14;

    for (int i = 0; i < 50; i++) {
        LINE_14_1(i) = -1;
    }
}
*/

#define lineas linea3, linea2, linea1, linea

//int i = 0; //_0-9 16-25

///*
int LINE_14[50] = int[50](-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

/*#define texto LINE_14
*/

#define bienvenida _B, _i, _e, _n, _v, _e, _n, _i, _d, _o, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1

void mainImage(out vec4 fragColor, in vec2 fragCoord) {  
    float SlugWidth = 8.0 * float(STRLEN);
    float Scale = max(round(iResolution.x / SlugWidth), 1.0);
       
    int Cursor = 1;
    vec4 Text = vec4(0.0);
    
    PRINT(LINE_14); //bienvenida);
    
    //PRINT(for (int i = 0; i < 50; i++) LINE_14[i]);
    
    fragColor.rgb = mix(vec3((fragCoord.x / iResolution.x + 1.0) / 2.0), Text.rgb, Text.a);
}
