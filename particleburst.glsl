/*
 * A silly example of simulating falling particles entirely within a fragment shader.
 */
const vec2 seed = vec2(0.5, 0.02);    // in a real application this would be a uniform
const vec2 center = vec2(0.5, 0.5);
const float SPEED = 0.2;
const float GRAVITY = 0.3;
const float NUM_PARTICLES = 20.0;
const float SIZE = 0.05;

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;

    fragColor = vec4(1.0);
    for (float i = 1.0; i <= NUM_PARTICLES; i++)
    {
        float x = (rand(seed + i) - 0.5) * SPEED * iTime;
        float y = ((rand(seed - i) - 0.5) * SPEED - GRAVITY * iTime) * iTime;
        
        vec2 coord = uv - vec2(x, y) - center;
        if (coord.x > 0.0 && coord.y > 0.0 && coord.x < SIZE && coord.y < SIZE)  // within bounds of the particle?
        {
            fragColor = texture(iChannel0, coord / SIZE);
        }
    }
}

