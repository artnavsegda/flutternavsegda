import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The third screen in the bottom navigation bar.
class UserPage extends StatelessWidget {
  /// Constructs a [UserPage] widget.
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('User Home'),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/user/details');
              },
              child: const Text('View user details'),
            ),
          ],
        ),
      ),
    );
  }
}
