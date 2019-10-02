/*
 * A screen tear effect similar to that from Doki Doki Literature Club, but modified to be
 * slightly more fragment shader friendly.
 * Rather than uniformly generating points for the rows to end on and then sorting those on the CPU,
 * this samples a power-law distribution to determine the width of each row.
 */
const vec2 seed = vec2(0.05, 0.1);  // pass as unifom
const int tearpoints = 10;  // number of rows to divide the screen into
const float offset = 0.1;   // maximum offset for a row when tearing
const float n = -3.0;  // power law distribution exponent
const float lower = 1000.0;  // another power law parameter

/* square wave parameters */
const float offPeriod = 0.1;  // time where row is not offset
const float onPeriod = 0.1;  // time where row is offset

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

vec4 applyOffset(vec2 uv, int i)
{
    float off = rand(seed - vec2(i)) * offPeriod;
    float on = rand(seed - vec2(i) * float(tearpoints * 2)) * onPeriod;

    float tOffset;
    float t = modf(iTime / (on + off), tOffset) * (on + off);

    float x = uv.x + float(t > off) + rand(tOffset - vec2(i) * float(tearpoints * 3)) * offset;

    return (x < 0.0) ? texture(iChannel0, uv) : texture(iChannel0, vec2(x, uv.y));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;
    float y = 0.0;
    
    for (int i = 0; i < tearpoints; i++)
    {
        y += pow((pow(1.0 - y, n) - lower) * rand(seed + vec2(i)) + lower, 1.0/n);

        if (uv.y < y)  // is point in row
        {
            fragColor = applyOffset(uv, i);
            return;
        }
    }
    
    fragColor = applyOffset(uv, tearpoints - 1);
}
