import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The first screen in the bottom navigation bar.
class MapPage extends StatelessWidget {
  /// Constructs a [MapPage] widget.
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Map screen'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/map/details');
              },
              child: const Text('View map details'),
            ),
          ],
        ),
      ),
    );
  }
}
