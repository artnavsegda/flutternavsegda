import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shellroute/main.dart';
import 'package:shellroute/pages/root.dart';
import 'package:shellroute/pages/map/map.dart';
import 'package:shellroute/pages/catalog/catalog.dart';
import 'package:shellroute/pages/home/home.dart';
import 'package:shellroute/pages/shopping/shopping.dart';
import 'package:shellroute/pages/user/user.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class TsehRouter {
  TsehRouter();
  late final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      /// Application shell
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainPage(child: child);
        },
        routes: <RouteBase>[
          /// The first screen to display in the bottom navigation bar.
          GoRoute(
            path: '/map',
            builder: (BuildContext context, GoRouterState state) {
              return const MapPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'Map');
                },
              ),
            ],
          ),

          /// Displayed when the second item in the the bottom navigation bar is
          /// selected.
          GoRoute(
            path: '/catalog',
            builder: (BuildContext context, GoRouterState state) {
              return const CatalogPage();
            },
            routes: <RouteBase>[
              /// Same as "/map/details", but displayed on the root Navigator by
              /// specifying [parentNavigatorKey]. This will cover both screen B
              /// and the application shell.
              GoRoute(
                path: 'details',
                //parentNavigatorKey: _rootNavigatorKey,
                parentNavigatorKey: _shellNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'Catalog');
                },
              ),
            ],
          ),

          /// The third screen to display in the bottom navigation bar.
          GoRoute(
            path: '/home',
            builder: (BuildContext context, GoRouterState state) {
              return const HomePage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'Home');
                },
              ),
            ],
          ),
          GoRoute(
            path: '/cart',
            builder: (BuildContext context, GoRouterState state) {
              return const ShoppingPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                parentNavigatorKey: _shellNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'Cart');
                },
              ),
            ],
          ),
          GoRoute(
            path: '/user',
            builder: (BuildContext context, GoRouterState state) {
              return const UserPage();
            },
            routes: <RouteBase>[
              // The details screen to display stacked on the inner Navigator.
              // This will cover screen A but not the application shell.
              GoRoute(
                path: 'details',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (BuildContext context, GoRouterState state) {
                  return const DetailsScreen(label: 'User');
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
