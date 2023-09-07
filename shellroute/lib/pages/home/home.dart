import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The third screen in the bottom navigation bar.
class HomePage extends StatelessWidget {
  /// Constructs a [HomePage] widget.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen Home'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/home/details');
              },
              child: const Text('View home details'),
            ),
          ],
        ),
      ),
    );
  }
}
