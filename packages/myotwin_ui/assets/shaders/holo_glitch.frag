#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform float u_time;
uniform float u_intensity; // The on/off spike (0.0 to 1.0)
uniform float u_severity;  // NEW: The violence multiplier (0.0 to 1.0)
uniform sampler2D u_texture;

out vec4 fragColor;

vec3 rgb2yiq(vec3 c){
    return vec3(
        (0.2989*c.x + 0.5959*c.y + 0.2115*c.z),
        (0.5870*c.x - 0.2744*c.y - 0.5229*c.z),
        (0.1140*c.x - 0.3216*c.y + 0.3114*c.z)
    );
}

vec3 yiq2rgb(vec3 c){
    return vec3(
        (1.0*c.x + 1.0*c.y + 1.0*c.z),
        (0.956*c.x - 0.2720*c.y - 1.1060*c.z),
        (0.6210*c.x - 0.6474*c.y + 1.7046*c.z)
    );
}

// Helper to fix Flutter's Premultiplied Alpha
vec3 unpremul(vec4 col) {
    return col.a > 0.0 ? col.rgb / col.a : vec3(0.0);
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec2 uv = FlutterFragCoord().xy / u_size;

    if (u_intensity <= 0.0) {
        fragColor = texture(u_texture, uv);
        return;
    }

    // --- THE DYNAMIC MATH ---
    // mix(min, max, slider) smoothly interpolates between the two values

    // 1. Band Thickness: 24.0 (thin/fine) down to 8.0 (chunky/thick)
    float bands = mix(24.0, 8.0, u_severity);
    float lineNoise = hash(vec2(floor(uv.y * bands), u_time));

    // 2. Tear Distance: 0.05 (tiny shift) up to 0.40 (massive throw)
    float maxTear = mix(0.05, 0.40, u_severity);

    float tear = 0.0;

    // 3. Frequency Threshold: Low severity = rare tears. High severity = many tears at once.
    float threshold = mix(0.9, 0.7, u_severity);
    if (lineNoise > threshold) {
        tear = (hash(vec2(uv.y, u_time)) - 0.5) * maxTear * u_intensity;
    }
    vec2 uvTear = uv + vec2(tear, 0.0);

    // 4. Color Split: 0.02 (tight) up to 0.15 (wide separation)
    float split = mix(0.02, 0.15, u_severity) * u_intensity;

    // Bounds Checking
    if (uvTear.x < 0.0 || uvTear.x > 1.0) {
        fragColor = vec4(0.0);
        return;
    }

    vec4 colCenter = texture(u_texture, uvTear);
    vec4 colLeft = texture(u_texture, clamp(uvTear - vec2(split, 0.0), 0.0, 1.0));
    vec4 colRight = texture(u_texture, clamp(uvTear + vec2(split, 0.0), 0.0, 1.0));

    vec3 rgbCenter = unpremul(colCenter);
    vec3 rgbLeft = unpremul(colLeft);
    vec3 rgbRight = unpremul(colRight);

    float y = rgb2yiq(rgbCenter).r;
    float i = rgb2yiq(rgbLeft).g;
    float q = rgb2yiq(rgbRight).b;

    vec3 glitchedRGB = yiq2rgb(vec3(y, i, q));
    fragColor = vec4(glitchedRGB * colCenter.a, colCenter.a);
}