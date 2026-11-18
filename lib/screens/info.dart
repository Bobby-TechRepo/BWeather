import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/screens/legal.dart';
import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Shows the installed version, e.g. "Version 1.0.0 (1)". Empty until loaded.
class AppVersionText extends StatelessWidget {
    final TextStyle? style;

    const AppVersionText({ super.key, this.style });

    /// Read once per app run.
    static final Future<PackageInfo> _info = PackageInfo.fromPlatform();

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<PackageInfo>(
            future: _info,
            builder: (context, snapshot) {
                final info = snapshot.data;
                if (info == null) return const SizedBox.shrink();
                final version = info.buildNumber.isEmpty ? info.version : "${info.version} (${info.buildNumber})";
                return Text(context.l10n.version(version), style: style);
            },
        );
    }
}

/// "About BWeather": description, version, data sources and legal links.
class Info extends StatelessWidget {
    static const String routeName = "info";

    const Info({ super.key });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;

        return Scaffold(
            appBar: AppBar(title: Text(l10n.aboutApp)),
            body: SafeArea(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                                Icon(Icons.cloud, size: 64, color: colors.primary),
                                const SizedBox(height: 8),
                                Text(l10n.appTitle, textAlign: TextAlign.center, style: theme.textTheme.headlineMedium?.copyWith(color: colors.primary)),
                                Center(child: AppVersionText(style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant))),
                                const SizedBox(height: 20),
                                Text(l10n.aboutDescription, style: theme.textTheme.bodyLarge),
                                const SizedBox(height: 24),
                                Text(l10n.aboutDataSources, style: theme.textTheme.titleMedium?.copyWith(color: colors.primary)),
                                const SizedBox(height: 8),
                                for (final line in [l10n.aboutOpenMeteo, l10n.aboutHistory, l10n.aboutCams, l10n.aboutRainViewer, l10n.aboutOsm, l10n.aboutIpapi, l10n.aboutIcons])
                                    Padding(padding: const EdgeInsets.only(bottom: 6), child: Text("• $line")),
                                const SizedBox(height: 16),
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.privacy_tip_outlined),
                                    title: Text(l10n.privacyPolicy),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => Navigator.of(context).pushNamed(LegalScreen.privacyRoute),
                                ),
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.gavel_outlined),
                                    title: Text(l10n.termsOfUse),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => Navigator.of(context).pushNamed(LegalScreen.termsRoute),
                                ),
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const Icon(Icons.description_outlined),
                                    title: Text(MaterialLocalizations.of(context).licensesPageTitle),
                                    trailing: const Icon(Icons.chevron_right),
                                    onTap: () => showLicensePage(context: context, applicationName: l10n.appTitle),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
