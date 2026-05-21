import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

/// An optical post-processing layer that applies a YIQ chromatic aberration
/// and horizontal tearing effect to its child.
///
/// NOTE: Because the shader displaces pixels horizontally, the [child] must
/// contain sufficient internal padding to prevent the tear from clipping against
/// the texture bounding box.
class HoloGlitch extends StatelessWidget {
  /// Creates a [HoloGlitch] that applies YIQ chromatic aberration and
  /// horizontal tearing to [child].
  ///
  /// [phase] is an ever-increasing time value used to drive the noise seed.
  /// [intensity] controls the spike magnitude (0.0–1.0).
  /// [severity] determines the tear distance and color split width (0.0–1.0).
  const HoloGlitch({
    super.key,
    required this.phase,
    required this.intensity,
    required this.severity,
    required this.child,
  });

  /// An ever-increasing time value used to drive the noise seed.
  final double phase;

  /// The active spike magnitude (0.0 to 1.0).
  /// 0.0 means the shader is completely dormant and passes the child through perfectly.
  final double intensity;

  /// The violence multiplier (0.0 to 1.0) determining the tear distance and color split width.
  final double severity;

  /// The widget to apply the glitch texture to.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      assetKey: 'packages/myotwin_ui/assets/shaders/holo_glitch.frag',
      (context, shader, _) {
        return AnimatedSampler(
          (image, size, canvas) {
            shader
              ..setFloat(0, size.width)
              ..setFloat(1, size.height)
              ..setFloat(2, phase * 15.0)
              ..setFloat(3, intensity)
              ..setFloat(4, severity)
              ..setImageSampler(0, image);

            canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
          },
          child: child,
        );
      },
    );
  }
}
