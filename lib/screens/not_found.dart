import 'package:bweather/l10n/l10n.dart';
import 'package:material_ui/material_ui.dart';

class NotFound extends StatelessWidget {
    const NotFound({ super.key });

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(context.l10n.pageNotFound)),
        );
    }
}
