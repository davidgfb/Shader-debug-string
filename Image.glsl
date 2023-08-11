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
 
//int a[] = int[](3, 4, 4, 2);

/*
tiene q tener 50 enteros x STRLEN. Si defino todos: numeros = 0,1,23456789
_A = mayusculas[a], _b = minusculas[b], _0 = numeros[0]
*/
const int _0 = 16, _1 = 17, _2 = 18, _3 = 19, _4 = 20, _5 = 21, _6 = 22, _7 = 23, 
    _8 = 24, _9 = 25;
//mayusculas
const int _A = 33, _B = 34, _C = 35, _D = 36, _E = 37, _F = 38, _G = 39, _H = 40, 
    _I = 41, _J = 42, _K = 43, _L = 44, _M = 45, _N = 46, _O = 47, _P = 48, _Q = 49, 
    _R = 50, _S = 51, _T = 52, _U = 53, _V = 54, _W = 55, _X = 56, _Y = 57, _Z = 58;
//minusculas
const int _a = 65, _b = 66, _c = 67, _d = 68, _e = 69, _f = 70, _g = 71, _h = 72, 
    _i = 73, _j = 74, _k = 75, _l = 76, _m = 77, _n = 78, _o = 79, _p = 80, _q = 81, 
    _r = 82, _s = 83, _t = 84, _u = 85, _v = 86, _w = 87, _x = 88, _y = 89, _z = 90;

/*
a partir de numeros altos se repite:
0-11 = 100-111, 0-4 = 95-99
*/
int[50] digitos = int[50](_0, _1, _2, _3, _4, _5, _6, _7, _8, _9, -1, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
int[50] mayusculas = int[50](_A, _B, _C, _D, _E, _F, _G, _H, _I, _J, _K, _L, _M, _N, _O,
    _P, _Q, _R, _S, _T, _U, _V, _W, _X, _Y, _Z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
int[50] minusculas = int[50](_a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o,
    _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
int[50] simbolos = int[50](0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,  26, 
    27, 28, 29, 30, 31, 32,  59, 60, 61, 62, 63, 64,  91, 92, 93, 94, -1, -1, -1, -1, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

/*
void once() {
    int LINE_14_1[50] = LINE_14;

    for (int i = 0; i < 50; i++) {
        LINE_14_1(i) = -1;
    }
}
*/

//int i = 0; //_0-9 16-25

int bienvenida[50] = int[50](_B, _i, _e, _n, _v, _e, _n, _i, _d, _o, 
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);

//shadertoy no permite array de array por ser GLSL < 3.1
//int[5][50] texto = int[5][50](simbolos, minusculas, mayusculas, digitos, bienvenida);

vec4 PRINT(int[50] texto, vec4 Text, vec2 fragCoord, float Scale, int Cursor) {
    Text += Print(fragCoord / Scale, ivec2(0, 8 * Cursor++), texto);
    
    return Text;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {  
    float SlugWidth = 8.0 * float(STRLEN);
    float Scale = max(round(iResolution.x / SlugWidth), 1.0);
       
    int Cursor = 1;
    vec4 Text = vec4(0.0);
    
    //int[10] -> int[50]
    //PRINT(int[50](int[10](_B, _i, _e, _n, _v, _e, _n, _i, _d, _o)));
     
    Text = PRINT(simbolos, Text, fragCoord, Scale, Cursor);
    
    /*
    PRINT(minusculas)
    PRINT(mayusculas);
    PRINT(digitos);
    PRINT(bienvenida); 
    */
    
    fragColor.rgb = mix(vec3((fragCoord.x / iResolution.x + 1.0) / 2.0), Text.rgb, Text.a);
}
