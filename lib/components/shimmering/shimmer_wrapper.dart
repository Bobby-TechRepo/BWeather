import 'package:material_ui/material_ui.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton shimmer using theme colours, so it looks right in dark mode too.
/// Children should paint their placeholder shapes in white; the shimmer
/// replaces that colour with the gradient.
class ShimmerWrapper extends StatelessWidget {
    final Widget child;
    final bool enabled;

    const ShimmerWrapper({ super.key, this.enabled = true, required this.child });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        return Shimmer.fromColors(
            baseColor: colors.surfaceContainerHighest,
            highlightColor: colors.surfaceContainerLow,
            enabled: enabled,
            child: child,
        );
    }
}
