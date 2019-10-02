/*
 * Demonstrating to myself how heightmaps get turned into normal maps.
 * Takes in a noise texture and uses it as a heightmap for some Lambertian surface.
 */
const float STEP = 1.0/512.0;  // how far on either side to sample the heightmap
const float STRENGTH = 0.1;    // normal strength

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord/iResolution.xy;

    /* shadertoy doesn't offer textureGather or textureOffset or anything nice like that... */
    float heightCenter = texture(iChannel0, uv).r;
    float heightX = texture(iChannel0, vec2(uv.x - STEP, uv.y)).r;
    float heightY = texture(iChannel0, vec2(uv.x, uv.y - STEP)).r;
    
    vec3 normal = normalize(cross(vec3(STEP, 0, STRENGTH * STEP * (heightCenter - heightX)), 
                                  vec3(0, STEP, STRENGTH * STEP * (heightCenter - heightY))));

    vec3 lightPos = vec3(0.5 * sin(iTime), 0.0, 0.6);
    fragColor = vec4(dot(normal, lightPos - vec3(uv - 0.5, 0.0)));
}

