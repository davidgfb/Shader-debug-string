// Generates the 4x4 matrix
// Expects _P any pixel coordinate
float B4( vec2 _P ) {
    /*
    vec2	P1 = mod( _P, 2.0 );					// (P >> 0) & 1
    vec2	P2 = floor( 0.5 * mod( _P, 4.0 ) );		// (P >> 1) & 1
    */
    
    return 0.0; //4.0*B2(P1) + B2(P2);
}

void mainImage( out vec4 fragColor, vec2 fragCoord ) {
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Time varying pixel color
    vec3 col = vec3(0); //0.5 + 0.5*cos(iTime+uv.xyx+vec3(0,2,4));
        
    int xPix = int(fragCoord.y), yPix = int(fragCoord.x);
    
    

    // Output to screen
    fragColor = vec4(col,1.0);
}
