// Short, theme-colored trail. Keep the original premultiplied alpha unchanged.
const float TRAIL_DURATION = 0.09;
const float TRAIL_OPACITY = 0.75;
const float TRAIL_MAX_CELLS = 20.0;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);

    float age = iTime - iTimeCursorChange;
    if (iFocus == 0 || iCursorVisible == 0 ||
        age < 0.0 || age >= TRAIL_DURATION) {
        return;
    }

    vec2 halfSize = iCurrentCursor.zw * 0.5;
    vec2 current = iCurrentCursor.xy + vec2(halfSize.x, -halfSize.y);
    vec2 previous = iPreviousCursor.xy +
                    iPreviousCursor.zw * vec2(0.5, -0.5);
    vec2 movement = previous - current;
    float distanceMoved = length(movement);
    if (distanceMoved < 1.0) {
        return;
    }

    // Leave the real cursor and the text beneath it untouched.
    vec2 point = fragCoord - current;
    if (all(lessThanEqual(abs(point), halfSize))) {
        return;
    }

    float progress = smoothstep(0.0, TRAIL_DURATION, age);
    float maxLength = TRAIL_MAX_CELLS * max(iCurrentCursor.z, 1.0);
    vec2 tail = movement * min(1.0, maxLength / distanceMoved) *
                (1.0 - progress);
    float lengthSquared = dot(tail, tail);
    if (lengthSquared < 1.0) {
        return;
    }

    float along = clamp(dot(point, tail) / lengthSquared, 0.0, 1.0);
    float radius = max(1.0, min(halfSize.x, halfSize.y)) *
                   mix(0.9, 0.15, along);
    float distanceToTrail = length(point - tail * along) - radius;
    float coverage = 1.0 - smoothstep(-0.5, 0.5, distanceToTrail);
    float opacity = TRAIL_OPACITY * coverage * (1.0 - progress)
                    * mix(1.0, 0.6, along) * iCurrentCursorColor.a;

    // The framebuffer is premultiplied: tint RGB without changing its alpha.
    fragColor.rgb = mix(fragColor.rgb,
                        iCurrentCursorColor.rgb * fragColor.a, opacity);
}
