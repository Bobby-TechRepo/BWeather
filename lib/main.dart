import 'dart:developer';
import 'dart:io';

import 'package:bweather/app.dart';
import 'package:bweather/services/alert_scheduler.dart';
import 'package:bweather/services/crash_reporting.dart';
import 'package:bweather/states/settings_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

/// Logs bloc lifecycle in debug builds only. It deliberately does not print
/// whole states: the weather state holds hundreds of hourly entries.
class DebugBlocObserver extends BlocObserver {
    const DebugBlocObserver();

    @override
    void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
        super.onChange(bloc, change);
        log('onChange -- ${bloc.runtimeType}: ${change.currentState.runtimeType} -> ${change.nextState.runtimeType}');
    }

    @override
    void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
        log('onError -- ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
        super.onError(bloc, error, stackTrace);
    }
}

Future<HydratedStorageDirectory> _storageDirectory() async {
    if (kIsWeb) {
        return HydratedStorageDirectory.web;
    }

    // Application *support* directory: unlike the temp/cache directory the OS
    // never clears it, so saved cities and settings survive low-storage cleanups.
    final directory = await getApplicationSupportDirectory();
    await _migrateFromTemporaryDirectory(directory);
    return HydratedStorageDirectory(directory.path);
}

/// Earlier builds stored state in the temporary directory. Copy it over once
/// so existing installs keep their cities and settings.
Future<void> _migrateFromTemporaryDirectory(Directory target) async {
    try {
        final source = await getTemporaryDirectory();
        if (!await source.exists()) return;

        await for (final entity in source.list()) {
            final name = entity.uri.pathSegments.last;
            if (entity is! File || !name.startsWith('hydrated_box') || name.endsWith('.lock')) continue;

            final destination = File('${target.path}${Platform.pathSeparator}$name');
            if (!await destination.exists()) {
                await target.create(recursive: true);
                await entity.copy(destination.path);
            }
        }
    } catch (error) {
        log('Storage migration skipped', error: error);
    }
}

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await _storageDirectory());
    if (kDebugMode) {
        Bloc.observer = const DebugBlocObserver();
    }
    await AlertScheduler.initializeBackground();
    CrashReporting.enabled = _savedCrashReportChoice();
    await CrashReporting.run(() => runApp(const App()));
}

/// The "Send crash reports" setting, read before the cubits exist so a user who
/// turned it off never sends a report from startup.
bool _savedCrashReportChoice() {
    try {
        final saved = HydratedBloc.storage.read(SettingsCubit.storageKey);
        if (saved is Map && saved[SettingsState.crashReportsKey] == false) return false;
    } catch (error) {
        log('Could not read the crash report setting', error: error);
    }
    return true;
}
