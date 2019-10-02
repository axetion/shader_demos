/*
 * A cool screensaver like effect.
 * Smoothly dissolves between a normal sine wave and its polar counterpart, the rose.
 * Scrolls through the colors of the visual light spectrum.
 */
const float amplitude = 0.25;  // amplitude of the wave
const float aFreq = 1.0;  // speed at which the amplitude changes
const float xFreq = 10.0;  // frequency of the wave
const float tFreq = 1.0;  // speed at which the wave scrolls
const float cFreq = 2.0;  // speed at which the colors scroll
const float rFreq = 5.0;  // speed at which the rose expands/contracts
const float thickness = 0.05;

/* Constants for converting from wavelength to XYZ color space */
const vec3 waveToX = vec3(0.362, 1.056, -0.065);
const vec2 waveToY = vec2(0.821, 0.286);
const vec2 waveToZ = vec2(1.217, 0.681);

/* Linear transform for XYZ to RGB */
const mat3 xyzTorgb = mat3(
    3.2406255, -0.9689307, 0.0557101,
    -1.537208, 1.8757561, -0.2040211,
    -0.4986286, 0.0415175, 1.0569959
);

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 uv = fragCoord / iResolution.xy - vec2(0.5, 0.5);

    /* Desired wavelength for color */
    float wave = mix(425.0, 650.0, 1.0/cFreq * abs(mod(iTime + uv.x, 2.0*cFreq) - cFreq));

    /* Convert to XYZ */
    vec3 t1 = vec3((wave - 442.0) * ((wave < 442.0) ? 0.0624 : 0.0374),
                   (wave - 599.8) * ((wave < 599.8) ? 0.0264 : 0.0323),
                   (wave - 501.1) * ((wave < 501.1) ? 0.0490 : 0.0382));
    
    t1 = exp(-0.5 * t1 * t1);
    
    vec2 t2 = vec2((wave - 568.8) * ((wave < 568.8) ? 0.0213 : 0.0247),
                   (wave - 530.9) * ((wave < 530.9) ? 0.0613 : 0.0322));
    
    t2 = exp(-0.5 * t2 * t2);
    
    vec2 t3 = vec2((wave - 437.0) * ((wave < 437.0) ? 0.0845 : 0.0278),
                   (wave - 459.0) * ((wave < 459.0) ? 0.0385 : 0.0725));
    
    t3 = exp(-0.5 * t3 * t3);

    vec3 xyz = vec3(dot(waveToX, t1), dot(waveToY, t2), dot(waveToZ, t3));

    /* Convert to RGB */
    vec3 rgb = clamp(xyzTorgb * xyz, 0.0, 1.0);

    vec3 threshold = vec3(lessThanEqual(rgb, vec3(0.0031308)));
    vec3 invert = 1.0 - threshold;

    rgb = rgb * threshold * 12.92 + 1.055 * pow(rgb * invert, vec3(0.41667)) - invert * 0.055;

    /* Compute wave shape */
    float theta = atan(uv.x, uv.y);
    float r = length(uv);
    
    float amp = amplitude * sin(aFreq * iTime);
    float phase = tFreq * iTime;

    float rectangularDist = abs(amp * sin(xFreq * uv.x + phase) - uv.y);
    float polarDist = abs(amp * sin(xFreq * theta + phase) - r);
    
    float dist = mix(rectangularDist, polarDist, clamp(abs(mod(iTime, 2.0 * rFreq) - rFreq) - rFreq / 2.0, 0.0, 1.0));
    fragColor = vec4((1.0 - min(dist / thickness, 1.0)) * rgb, 1.0);
}
