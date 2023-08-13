void mainImage( out vec4 fragColor, in vec2 fragCoord ) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    //vec3 col = 0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
       
    vec3 col = vec3(0);
    
    /*int[] igual = int[](0xF, 0, 0, 0xF); //0xF00F;
      
    for (int posFila = 0; posFila < 4; posFila++) {
        int nFila = igual[posFila]; //15
        
        //equivalente en iterativo a %2, %2%2, %2%2%2...
        int _4 = nFila % 2, _3 = _4 % 2, _2 = _3 % 2, _1 = _2 % 2;
        
        int[] nBin = int[](_1, _2, _3, _4); 
        
        //cjto
        int bin = 1000 * _1 + 100 * _2 + 10 * _3 + _4;
        
        //
        
        
        //for (int nCol = 0; nCol < 4; nCol++) {
        //    fila[nCol];
        //}
        
    }
    */
    
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x);    
    
    ///*
    //hex -> bin, 0001
    int hex = 1, _4 = hex % 2, _3 = _4 % 2, _2 = _3 % 2, _1 = _2 % 2; //, 
    int[] aBin = int[](_1, _2, _3, _4);     
    int nElems = aBin.length();
    
    if (xPix == 200) col = vec3(aBin[yPix % nElems]);
    
    /*
    for (int nElem = 0; nElem < nElems; nElem++) {
        if (yPix == nElem) {
            col = vec3(1);
        }
    }
    */
    
    
    
    
    //bin = 1000 * _1 + 100 * _2 + 10 * _3 + _4;
        
    
    
    //if (bin == hex) col = vec3(1); //NO es igual hex q bin!!
    //*/
    
    
    
    
    
    /*
    //par impar
    //esPar
    if (xPix % 2 == 0) {
        col = vec3(1);
    }
    */

    // Output to screen. Hay que normalizarlo ie dividirlo entre iRes
    fragColor = vec4(col, 1.0);
}
