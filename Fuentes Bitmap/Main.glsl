vec2 MAP_SIZE = vec2(4, 5);

/*
	returns the status of a bit in a bitmap. This is done value-wise, so
	the exact representation of the float doesn't really matter.
*/
float getBit( in float map, in float index )
{
    // Ooh -index takes out that divide :)
    return mod( floor( map*exp2(-index) ), 2.0 );
}

/*
  Draws a character, given its encoded value, a position, size and
  current [0..1] uv coordinate.
*/
float drawChar( float char, vec2 pos, vec2 size, vec2 uv )
{
  // Subtract our position from the current uv so that we can
  // know if we're inside the bounding box or not.
  uv-=pos;
  
  // Divide the screen space by the size, so our bounding box is 1x1.
  uv /= size;
  
  // Bounding box check.
  if( min(uv.x,uv.y) < 0.0 && max(uv.x,uv.y) > 1.0 ) return 0.0;
  
  // Go ahead and multiply the UV by the bitmap size so we can work in
  // bitmap space coordinates.
  uv *= MAP_SIZE;
  
  // Get the appropriate bit and return it.
  return getBit( char, 4.0*floor(uv.y) + floor(uv.x) );
}

float CH_B = float(0x79797);

float text( in vec2 uv )
{
    // Set a general character size...
    vec2 charSize = 16.0*vec2(.03, .0375);
    // and a starting position.
    vec2 charPos = vec2(4.05, 0.90);
    
    // Draw some text!
    float chr = 0.0;
    
    chr += drawChar( CH_B, charPos, charSize, uv);
    
    return chr;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    //vec2 uv = fragCoord/iResolution.xy;

    // Get normalized UV coords.
	vec2 uv = 2.0*fragCoord.xy / iResolution.xy;
    uv.x *= 4.0*iResolution.x / iResolution.y; //fix aspect ratio

    // Draw some text!
    float txt = text(uv);

    // Output to screen
    fragColor = vec4(txt, txt, txt, 1.0);
}
