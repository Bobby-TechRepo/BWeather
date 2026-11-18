import 'dart:async';

import 'package:bweather/l10n/l10n.dart';
import 'package:bweather/utils/utils.dart';
import 'package:bweather_repository/bweather_repository.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// The place the radar opens on.
class RadarTarget {
    final double latitude, longitude;
    final String name;

    const RadarTarget({ required this.latitude, required this.longitude, required this.name });
}

/// Rain radar for the past ~2 hours: OpenStreetMap base map with RainViewer
/// radar tiles on top.
///
/// RainViewer's free API: 256 px tiles up to zoom 7, past frames only,
/// at most 100 requests per minute per IP, and the credit
/// "Weather data by RainViewer" must stay visible. So frames are loaded one at
/// a time (never preloaded), playback is slow, and the map stops at zoom 10.
/// OpenStreetMap tiles require the "© OpenStreetMap contributors" credit and
/// an identifying User-Agent.
class RadarScreen extends StatefulWidget {
    static const String routeName = "radar";

    final RadarTarget target;

    const RadarScreen({ super.key, required this.target });

    @override
    State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
    static const userAgentPackageName = 'com.bsoft.bweather';
    static const osmTiles = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    static const radarMaxNativeZoom = 7;
    static const mapMaxZoom = 10.0;
    static const frameInterval = Duration(milliseconds: 1200);

    final MapController _map = MapController();
    RadarFrames? _frames;
    bool _failed = false;
    int _index = 0;
    Timer? _player;

    @override
    void initState() {
        super.initState();
        unawaited(_load());
    }

    @override
    void dispose() {
        _player?.cancel();
        _map.dispose();
        super.dispose();
    }

    Future<void> _load() async {
        if (_failed) setState(() => _failed = false); // retry: show the spinner again
        try {
            final frames = await context.read<ForecastRepository>().radarFrames();
            if (!mounted) return;
            setState(() {
                _frames = frames;
                _failed = frames.past.isEmpty;
                _index = frames.past.isEmpty ? 0 : frames.past.length - 1; // latest
            });
        } catch (_) {
            if (mounted) setState(() => _failed = true);
        }
    }

    void _togglePlay() {
        final frames = _frames;
        if (frames == null || frames.past.length < 2) return;
        if (_player != null) {
            setState(() {
                _player?.cancel();
                _player = null;
            });
            return;
        }
        // Every other frame keeps a full loop well inside RainViewer's rate
        // limit; tiles are cached after the first loop.
        setState(() {
            _player = Timer.periodic(frameInterval, (_) {
                if (!mounted) return;
                final count = frames.past.length;
                // Loop so the newest frame is always shown.
                final first = (count - 1) % 2;
                setState(() => _index = _index + 2 > count - 1 ? first : _index + 2);
            });
        });
    }

    void _zoom(double delta) {
        final camera = _map.camera;
        _map.move(camera.center, (camera.zoom + delta).clamp(2.0, mapMaxZoom).toDouble());
    }

    static Future<void> _open(String url) async {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }

    @override
    Widget build(BuildContext context) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        final colors = theme.colorScheme;
        final dark = theme.brightness == Brightness.dark;
        final target = widget.target;
        final center = LatLng(target.latitude, target.longitude);
        final frames = _frames;
        final frame = (frames == null || frames.past.isEmpty) ? null : frames.past[_index];

        return Scaffold(
            appBar: AppBar(title: Text("${l10n.radar} · ${target.name}")),
            body: Stack(children: [
                FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                        initialCenter: center, initialZoom: 6, minZoom: 2, maxZoom: mapMaxZoom,
                        backgroundColor: colors.surfaceContainerHighest,
                    ),
                    children: [
                        TileLayer(
                            urlTemplate: osmTiles,
                            userAgentPackageName: userAgentPackageName,
                            tileBuilder: dark ? darkModeTileBuilder : null,
                        ),
                        if (frame != null)
                            TileLayer(
                                key: const ValueKey("radar"),
                                urlTemplate: "${frames!.host}${frame.path}/256/{z}/{x}/{y}/2/1_1.png",
                                maxNativeZoom: radarMaxNativeZoom,
                                panBuffer: 0,
                                userAgentPackageName: userAgentPackageName,
                                tileDisplay: const TileDisplay.instantaneous(opacity: 0.75),
                            ),
                        MarkerLayer(markers: [
                            Marker(
                                point: center, width: 36, height: 36, alignment: Alignment.topCenter, // pin tip on the place
                                child: Icon(Icons.location_on, size: 36, color: colors.primary, semanticLabel: target.name),
                            ),
                        ]),
                    ],
                ),
                // Zoom buttons for mouse and keyboard users.
                Positioned(
                    right: 12, top: 12,
                    child: Card(
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                            IconButton(icon: const Icon(Icons.add), tooltip: context.l10n.zoomIn, onPressed: () => _zoom(1)),
                            IconButton(icon: const Icon(Icons.remove), tooltip: context.l10n.zoomOut, onPressed: () => _zoom(-1)),
                            IconButton(icon: const Icon(Icons.my_location), tooltip: target.name, onPressed: () => _map.move(center, _map.camera.zoom)),
                        ]),
                    ),
                ),
                Positioned(
                    left: 0, right: 0, bottom: 0,
                    child: SafeArea(
                        top: false,
                        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                                child: Card(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: _controls(context, frames, frame),
                                    ),
                                ),
                            ),
                            _Attribution(onOsm: () => _open("https://www.openstreetmap.org/copyright"), onRainViewer: () => _open("https://www.rainviewer.com/")),
                        ]),
                    ),
                ),
            ]),
        );
    }

    Widget _controls(BuildContext context, RadarFrames? frames, ({int time, String path})? frame) {
        final l10n = context.l10n;
        if (_failed) {
            return Row(children: [
                const Icon(Icons.cloud_off),
                const SizedBox(width: 8),
                Expanded(child: Text(l10n.radarUnavailable)),
                TextButton(onPressed: _load, child: Text(l10n.retry)),
            ]);
        }
        if (frames == null || frame == null) {
            return const Padding(padding: EdgeInsets.all(12), child: LinearProgressIndicator());
        }

        final time = DateTime.fromMillisecondsSinceEpoch(frame.time * 1000);
        final minutesAgo = DateTime.now().difference(time).inMinutes;
        final playing = _player != null;

        return Column(mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
                IconButton(
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    tooltip: playing ? l10n.pause : l10n.play,
                    onPressed: frames.past.length < 2 ? null : _togglePlay,
                ),
                Expanded(
                    child: Slider(
                        value: _index.toDouble(),
                        min: 0,
                        max: (frames.past.length - 1).toDouble(),
                        divisions: frames.past.length > 1 ? frames.past.length - 1 : null,
                        onChanged: frames.past.length < 2 ? null : (value) => setState(() => _index = value.round()),
                    ),
                ),
                SizedBox(
                    width: 96,
                    child: Text(
                        "${formatClock(time, context.localeName)}\n${minutesAgo <= 1 ? l10n.ageJustNow : l10n.ageMinutes(minutesAgo)}",
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.bodySmall,
                    ),
                ),
            ]),
            Text(l10n.radarNoCoverage, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
        ]);
    }
}

/// Required credits for the map and radar data, each linking to its source.
class _Attribution extends StatelessWidget {
    final VoidCallback onOsm, onRainViewer;

    const _Attribution({ required this.onOsm, required this.onRainViewer });

    @override
    Widget build(BuildContext context) {
        final colors = Theme.of(context).colorScheme;
        final style = TextStyle(fontSize: 12, color: colors.onSurface, decoration: TextDecoration.underline);
        return ColoredBox(
            color: colors.surface.withValues(alpha: 0.85),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // Not translated: these are the providers' required wording.
                child: Wrap(alignment: WrapAlignment.end, spacing: 12, children: [
                    InkWell(onTap: onOsm, child: Text("© OpenStreetMap contributors", style: style)),
                    InkWell(onTap: onRainViewer, child: Text("Weather data by RainViewer", style: style)),
                ]),
            ),
        );
    }
}
