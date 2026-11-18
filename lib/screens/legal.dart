import 'package:bweather/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

enum LegalDocument { privacy, terms }

/// In-app Privacy Policy and Terms of Use.
///
/// NOTE: have these texts reviewed before publishing, and host the privacy
/// policy at a public URL as well: Google Play requires a link to it.
class LegalScreen extends StatelessWidget {
    static const String privacyRoute = "privacy";
    static const String termsRoute = "terms";

    /// Bump when the texts change.
    static final DateTime lastUpdated = DateTime(2026, 11, 14);

    final LegalDocument document;

    const LegalScreen({ super.key, required this.document });

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);

        final (String title, String intro, List<(String, String)> sections) = switch (document) {
            LegalDocument.privacy => (l10n.privacyPolicy, l10n.privacyIntro, [
                (l10n.privacyLocationTitle, l10n.privacyLocationBody),
                (l10n.privacyApproximateTitle, l10n.privacyApproximateBody),
                (l10n.privacySearchTitle, l10n.privacySearchBody),
                (l10n.privacyRadarTitle, l10n.privacyRadarBody),
                (l10n.privacyTripsTitle, l10n.privacyTripsBody),
                (l10n.privacyCrashTitle, l10n.privacyCrashBody),
                (l10n.privacyStorageTitle, l10n.privacyStorageBody),
                (l10n.privacyContactTitle, l10n.privacyContactBody),
            ]),
            LegalDocument.terms => (l10n.termsOfUse, l10n.termsIntro, [
                (l10n.termsAccuracyTitle, l10n.termsAccuracyBody),
                (l10n.termsServiceTitle, l10n.termsServiceBody),
                (l10n.termsThirdPartyTitle, l10n.termsThirdPartyBody),
            ]),
        };

        final date = MaterialLocalizations.of(context).formatMediumDate(lastUpdated);

        return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: SafeArea(
                child: Center(
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: ListView(
                            padding: const EdgeInsets.all(20),
                            children: [
                                Text(l10n.legalLastUpdated(date), style: theme.textTheme.bodySmall),
                                const SizedBox(height: 12),
                                Text(intro, style: theme.textTheme.bodyLarge),
                                for (final section in sections) ...[
                                    const SizedBox(height: 20),
                                    Text(section.$1, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary)),
                                    const SizedBox(height: 6),
                                    Text(section.$2, style: theme.textTheme.bodyMedium),
                                ],
                            ],
                        ),
                    ),
                ),
            ),
        );
    }
}
