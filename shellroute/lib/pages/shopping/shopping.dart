import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The third screen in the bottom navigation bar.
class ShoppingPage extends StatelessWidget {
  /// Constructs a [ShoppingPage] widget.
  const ShoppingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Screen Cart'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/cart/details');
              },
              child: const Text('View cart details'),
            ),
          ],
        ),
      ),
    );
  }
}
