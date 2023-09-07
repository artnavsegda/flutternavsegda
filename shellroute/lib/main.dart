import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shellroute/router/routes.dart';

// This scenario demonstrates how to set up nested navigation using ShellRoute,
// which is a pattern where an additional Navigator is placed in the widget tree
// to be used instead of the root navigator. This allows deep-links to display
// pages along with other UI components such as a BottomNavigationBar.
//
// This example demonstrates how to display a route within a ShellRoute and also
// push a screen using a different navigator (such as the root Navigator) by
// providing a `parentNavigatorKey`.

void main() {
  runApp(ShellRouteExampleApp());
}

/// An example demonstrating how to use [ShellRoute]
class ShellRouteExampleApp extends StatefulWidget {
  /// Creates a [ShellRouteExampleApp]
  ShellRouteExampleApp({super.key});

  @override
  State<ShellRouteExampleApp> createState() => _ShellRouteExampleAppState();
}

class _ShellRouteExampleAppState extends State<ShellRouteExampleApp> {
  late TsehRouter tsehRouter;

  @override
  void initState() {
    super.initState();
    tsehRouter = TsehRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      routerConfig: tsehRouter.router,
    );
  }
}

/// The details screen for either the A, B or C screen.
class DetailsScreen extends StatelessWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    super.key,
  });

  /// The label to display in the center of the screen.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Screen'),
      ),
      body: Center(
        child: Text(
          'Details for $label',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
