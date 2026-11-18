import 'package:material_ui/material_ui.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// One tile in the details grid: icon, big value, small title.
class Details extends StatelessWidget {
    final String title, info;

    /// Asset path, e.g. "files/icons/meteocons--sunrise-fill.svg".
    final String iconAsset;

    const Details({ super.key, required this.title, required this.info, required this.iconAsset });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;

        return Semantics(
            label: "$title: $info",
            excludeSemantics: true,
            child: Container(
                decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.all(12),
                alignment: Alignment.center,
                child: Row(children: [
                    SvgPicture.asset(iconAsset, width: 36, fit: BoxFit.fitWidth),
                    const SizedBox(width: 10),
                    Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(info, maxLines: 1, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: colors.onSurface)),
                        ),
                        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant)),
                    ])),
                ]),
            ),
        );
    }
}
