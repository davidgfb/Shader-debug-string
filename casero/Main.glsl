void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));

    int[] igual = int[](0xF, 0, 0, 0xF); //0xF00F;
    
    //int _0xF = 
    
    for (int posFila = 0; posFila < 4; posFila++) {
        int nFila = igual[posFila]; //15
        
        //equivalente en iterativo a %2, %2%2, %2%2%2...
        int _4 = nFila % 2, _3 = _4 % 2, _2 = _3 % 2, _1 = _2 % 2;
        
        int[] nBin = int[](_1, _2, _3, _4);
        
        /*
        for (int nCol = 0; nCol < 4; nCol++) {
            fila[nCol];
        }
        */
    }
    
    int xPix = int(fragCoord.x), yPix = int(fragCoord.y);
    
    vec3 col = vec3(0);
    
    //par impar
    //esPar
    if (xPix % 2 == 0) {
        col = vec3(1);
    }

    // Output to screen. Hay que normalizarlo ie dividirlo entre iRes
    fragColor = vec4(col, 1.0);
}
