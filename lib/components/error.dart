import 'package:bweather/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget{
    final String message;
    final VoidCallback? onRetry;

    const ErrorView({ super.key, required this.message, this.onRetry });

    @override
    Widget build(BuildContext context) {
        final ColorScheme theme = Theme.of(context).colorScheme;

        return Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Lottie.asset('files/animations/Not found.json', width: 200, fit: BoxFit.fitWidth),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: theme.error, fontSize: 14, fontWeight: FontWeight.w300, letterSpacing: 1.4)),
                ),
                if (onRetry != null) ...[
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: onRetry,
                        child: Text(context.l10n.retry),
                    )
                ]
        ]);
    }
}
