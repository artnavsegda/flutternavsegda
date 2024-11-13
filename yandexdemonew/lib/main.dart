import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/init.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';
import 'package:yandex_maps_mapkit/image.dart' as image_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initMapkit(apiKey: "0ea7608d-c007-4bf7-87ac-39877f4e108e");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapWindow? _mapWindow;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(body: FlutterMapWidget(onMapCreated: (mapWindow) {
      _mapWindow = mapWindow;
      print('start');

      mapWindow.map.move(CameraPosition(
          Point(latitude: 55.751225, longitude: 37.62954),
          zoom: 17.0,
          azimuth: 150.0,
          tilt: 30.0));

      final imageProvider = image_provider.ImageProvider.fromImageProvider(
          const AssetImage("assets/place.png"));
      final placemarkTapListener =
          MapObjectTapListenerImpl(onMapObjectTapped: (mapObject, point) {
        print('tap');
        showSnackBar(
          context,
          "Tapped the placemark",
        );
        return true;
      });
      final placemark = mapWindow.map.mapObjects.addPlacemark()
        ..geometry = const Point(latitude: 55.751225, longitude: 37.62954)
        ..setIcon(imageProvider)
        ..setIconStyle(
          const IconStyle(
            anchor: math.Point(0.5, 1.0),
            scale: 1.0,
          ),
        )
        ..addTapListener(placemarkTapListener);
    })));
  }
}

final class FlutterMapWidget extends StatefulWidget {
  final void Function(MapWindow) onMapCreated;
  final VoidCallback? onMapDispose;

  const FlutterMapWidget({
    super.key,
    required this.onMapCreated,
    this.onMapDispose,
  });

  @override
  State<FlutterMapWidget> createState() => FlutterMapWidgetState();
}

final class FlutterMapWidgetState extends State<FlutterMapWidget> {
  late final AppLifecycleListener _lifecycleListener;

  MapWindow? _mapWindow;
  bool _isMapkitActive = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: YandexMap(
        onMapCreated: _onMapCreated,
        platformViewType: PlatformViewType.Hybrid,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startMapkit();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _startMapkit();
        _setMapTheme();
      },
      onInactive: () {
        _stopMapkit();
      },
    );
  }

  @override
  void dispose() {
    _stopMapkit();
    _lifecycleListener.dispose();
    widget.onMapDispose?.call();
    super.dispose();
  }

  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();
    }
  }

  void _onMapCreated(MapWindow window) {
    window.let((it) {
      widget.onMapCreated(window);
      _mapWindow = it;

      it.map.logo.setAlignment(
        const LogoAlignment(
          LogoHorizontalAlignment.Left,
          LogoVerticalAlignment.Bottom,
        ),
      );
    });

    _setMapTheme();
  }

  void _setMapTheme() {
    _mapWindow?.map.nightModeEnabled =
        Theme.of(context).brightness == Brightness.dark;
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T it) block) => block(this);
}

final class MapObjectTapListenerImpl implements MapObjectTapListener {
  final bool Function(MapObject, Point) onMapObjectTapped;

  const MapObjectTapListenerImpl({required this.onMapObjectTapped});

  @override
  bool onMapObjectTap(MapObject mapObject, Point point) {
    return onMapObjectTapped(mapObject, point);
  }
}

bool showSnackBar(BuildContext? context, String text) {
  final isShown = context?.let((it) {
    final snackBar = _getSnackBar(it, text);
    ScaffoldMessenger.of(it).showSnackBar(snackBar);
    return true;
  });
  return isShown ?? false;
}

SnackBar _getSnackBar(BuildContext context, String text) {
  return SnackBar(
    showCloseIcon: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    closeIconColor: Theme.of(context).colorScheme.secondary,
    duration: const Duration(milliseconds: 1000),
    behavior: SnackBarBehavior.floating,
    content: Text(
      text,
      style: Theme.of(context).textTheme.labelLarge,
    ),
  );
}
