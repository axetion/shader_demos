/*
 * Shader I used for a "magical transformation" animation. 
 * Colored voronoi noise raised to an exponent to create sharp edges between cells,
 * with the cell centers being moved around by a cycloid.
 * I also added the TIMEQUANTIZE variable to adjust the framerate of the animation,
 * allowing for an intentionally low framerate/retro look.
 */

const vec4 COLOR = vec4(0.2, 0.6, 0.3, 1.0);
const float SCALE = 8.0;    // scale for the UVs
const float TIMEQUANTIZE = 0.07;    // round current time off to nearest TIMEQUANTIZE
const float EXP = 2.5;    // exponent for the vornoi noise
const float TFREQ = 2.0;    // speed the cells move
const float XFREQ = 5.0;    // spread of the cells

vec2 hash(vec2 p)  // uniformly random numbers
{
    vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.0973));
    p3 += dot(p3, p3.yzx + 33.33);

    return fract((p3.xx + p3.yz) * p3.zy);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy * SCALE;

    /* standard voronoi noise generation */
    vec2 cell;
    vec2 pos1 = modf(uv, cell);
    float dist = 1.0f;

    for (int x = -1; x <= 1; x++)
    {
        for (int y = -1; y <= 1; y++)
        {
            vec2 pos2 = vec2(x, y);
            pos2 = pos2 + abs(sin(TFREQ * floor(iTime / TIMEQUANTIZE) * TIMEQUANTIZE + XFREQ * hash(cell + pos2)));  // animation bit

            dist = min(dist, distance(pos1, pos2));
        }
    }
    
    fragColor = COLOR + (1.0 - COLOR) * pow(dist, EXP);
}
