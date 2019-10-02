/*
 * A simple background.
 * Tiled, cool-colored hexagons scrolling with a curvature effect to make it appear to be rotating.
 * Some vignette is used to hide the extreme ends of the curvature and bring focus to the center.
 */
const float TIME_FREQ = -0.25;    // scroll speed
const float POLY_FREQ = 0.52359877559;    // determines how many sides the polygon has; this makes it a hexagon
const float STROKE = 0.03;    // line length
const float AREA = 0.1;    // size of each hexagon
const float VIGNETTE = 0.6;    // vignette strength
const vec4 COLOR = vec4(0.5, 0.5, 0.7, 1.0);

const mat2 TRANSFORM = mat2(0.5, 0, sqrt(3.0) / 6.0, 1.0 / sqrt(3.0));

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy - vec2(0.5);
    float r1 = length(uv);

    vec2 bend = (vec2(uv.x, uv.y + TIME_FREQ * iTime) - r1 * r1 * uv) / AREA;
    vec2 grid = inverse(TRANSFORM) * round(TRANSFORM * bend) - bend;

    float r2 = length(grid);
    float theta = atan(grid.y, grid.x);

    float polygon = 0.85 * cos(POLY_FREQ) / cos(mod(theta + POLY_FREQ, 2.0 * POLY_FREQ) - POLY_FREQ);
    float dist = abs(r2 - polygon);
 
    fragColor = (VIGNETTE - r1) * (dist < STROKE ? COLOR : vec4(0.0));
}
