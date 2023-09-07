import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The second screen in the bottom navigation bar.
class CatalogPage extends StatelessWidget {
  /// Constructs a [CatalogPage] widget.
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen Catalog'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/catalog/details');
              },
              child: const Text('View catalog details'),
            ),
          ],
        ),
      ),
    );
  }
}
