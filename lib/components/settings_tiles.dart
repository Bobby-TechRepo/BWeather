import 'package:material_ui/material_ui.dart';

/// Building blocks for grouped settings lists: a section title, a rounded
/// group with hairline dividers, and rows with a coloured icon tile.

/// Icon tile colours, chosen to read well on light and dark surfaces.
class SettingsColors {
    const SettingsColors._();

    static const blue = Color(0xFF2F7BD8);
    static const indigo = Color(0xFF5B5BD6);
    static const teal = Color(0xFF14958A);
    static const green = Color(0xFF2E9D57);
    static const orange = Color(0xFFE07B1F);
    static const red = Color(0xFFD9443B);
    static const pink = Color(0xFFD14B8F);
    static const grey = Color(0xFF6B7684);
}

class SettingsSection extends StatelessWidget {
    final String? title;
    final List<Widget> children;

    /// Small print under the group (e.g. how alerts are checked).
    final String? footer;

    const SettingsSection({ super.key, this.title, required this.children, this.footer });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (title != null)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                        child: Semantics(
                            header: true,
                            child: Text(
                                title!.toUpperCase(),
                                style: theme.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                            ),
                        ),
                    ),
                Material(
                    color: colors.surfaceContainerLow,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                        for (int i = 0; i < children.length; i++) ...[
                            if (i > 0) const Divider(indent: 64),
                            children[i],
                        ],
                    ]),
                ),
                if (footer != null)
                    Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                        child: Text(footer!, style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                    ),
            ]),
        );
    }
}

/// A rounded square with a white icon, like system settings apps use.
class SettingsIcon extends StatelessWidget {
    final IconData icon;
    final Color color;

    const SettingsIcon(this.icon, this.color, { super.key });

    @override
    Widget build(BuildContext context) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: Colors.white, size: 20),
    );
}

/// A row that opens something: shows the current [value] and a chevron.
class SettingsTile extends StatelessWidget {
    final IconData icon;
    final Color color;
    final String title;
    final String? subtitle, value;
    final VoidCallback? onTap;
    final Widget? trailing;

    const SettingsTile({ super.key, required this.icon, required this.color, required this.title, this.subtitle, this.value, this.onTap, this.trailing });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return ListTile(
            leading: SettingsIcon(icon, color),
            title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            subtitle: subtitle == null ? null : Text(subtitle!),
            onTap: onTap,
            trailing: trailing ?? (onTap == null
                ? null
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    if (value != null)
                        ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 160),
                            child: Text(value!, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ),
                    const SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
                ])),
        );
    }
}

class SettingsSwitchTile extends StatelessWidget {
    final IconData icon;
    final Color color;
    final String title;
    final String? subtitle;
    final bool value;
    final ValueChanged<bool> onChanged;

    const SettingsSwitchTile({ super.key, required this.icon, required this.color, required this.title, this.subtitle, required this.value, required this.onChanged });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        return SwitchListTile(
            secondary: SettingsIcon(icon, color),
            title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            subtitle: subtitle == null ? null : Text(subtitle!),
            value: value,
            onChanged: onChanged,
        );
    }
}

/// A row with a segmented control, for short choices like units.
/// On narrow screens the control drops below the title.
class SettingsSegmentedTile<T> extends StatelessWidget {
    final IconData icon;
    final Color color;
    final String title;
    final T value;

    /// Value → (short label, optional tooltip/semantic label).
    final Map<T, (String, String?)> options;
    final ValueChanged<T> onChanged;

    const SettingsSegmentedTile({ super.key, required this.icon, required this.color, required this.title, required this.value, required this.options, required this.onChanged });

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);
        final control = SegmentedButton<T>(
            showSelectedIcon: false,
            segments: [
                for (final option in options.entries)
                    ButtonSegment<T>(value: option.key, label: Text(option.value.$1), tooltip: option.value.$2),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
        );

        return LayoutBuilder(builder: (context, constraints) {
            // Large system text needs the full row for the buttons.
            final largeText = MediaQuery.textScalerOf(context).scale(1) > 1.3;
            final stacked = largeText || constraints.maxWidth < 120.0 + 72.0 * options.length + 120;
            final label = Row(children: [
                SettingsIcon(icon, color),
                const SizedBox(width: 16),
                Expanded(child: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500))),
            ]);
            return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: stacked
                    ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        label,
                        const SizedBox(height: 12),
                        Padding(padding: const EdgeInsets.only(left: 50), child: control),
                    ])
                    : Row(children: [Expanded(child: label), control]),
            );
        });
    }
}

/// Bottom sheet with a list of choices; returns the picked value, or null.
Future<T?> showChoiceSheet<T>(BuildContext context, { required String title, required Map<T, String> options, required T value }) {
    return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
            final theme = Theme.of(context);
            return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.75),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                        child: Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                    ),
                    Flexible(
                        child: ListView(shrinkWrap: true, padding: const EdgeInsets.only(bottom: 16), children: [
                            for (final option in options.entries)
                                ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                                    title: Text(option.value),
                                    selected: option.key == value,
                                    trailing: option.key == value ? Icon(Icons.check_circle, color: theme.colorScheme.primary) : null,
                                    onTap: () => Navigator.of(context).pop(option.key),
                                ),
                        ]),
                    ),
                ]),
            );
        },
    );
}
