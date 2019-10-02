/*
 * A water-esque ripple effect, designed for a dark area with dramatic spot lighting.
 */
const float RIPPLES = 10.0f;  // number of ripples
const float AMP = 2.5f;  // amplitude
const float AFALLOFF = 0.6f;  // falloff of amplitude with each consecutive ripple
const float FFALLOFF = 10.0f;  // falloff of length with each consecutive ripple
const float FREQ = 20.0f;  // speed
const float LIGHTCONE = 3.14f;  // affects how much of the ripple is lit
const float EXP = 6.0f;  // phong-ish exponent

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    fragCoord -= iResolution.xy / 2.0;
    float r = length(fragCoord);
    float theta = atan(fragCoord.y, fragCoord.x);
    
    float height = 0.0f;

    for (float i = 1.0f; i <= RIPPLES; i++)
    {
        float amp = AMP * exp(-AFALLOFF * i * iTime);
        float phase = i * r / FFALLOFF - FREQ * iTime; 
        height -= amp * phase * exp(-phase * phase);
    }

    height *= abs(theta / LIGHTCONE);
    fragColor = vec4(pow(height, EXP));
}
