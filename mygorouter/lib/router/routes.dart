import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_state.dart';
import '../pages/login.dart';
import '../pages/onboarding.dart';
import '../pages/home.dart';
import '../pages/product.dart';
import '../pages/splash.dart';

class NordRouter {
  final LoginState loginState;
  NordRouter(this.loginState);
  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: false,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'main'}),
      ),
      GoRoute(
        name: 'welcome',
        path: '/welcome',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const OnboardingPage(),
        ),
      ),
      GoRoute(
        name: 'splash',
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
          name: 'home',
          path: '/home/:tab(main|shop|cart|profile|more)',
          pageBuilder: (context, state) {
            final tab = state.params['tab']!;
            return MaterialPage<void>(
              key: state.pageKey,
              child: HomePage(tab: tab),
            );
          },
          routes: [
            GoRoute(
              name: 'product',
              path: 'product/:id',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: Product(id: int.parse(state.params['id']!)),
              ),
            ),
/*             GoRoute(
              name: 'catalog',
              path: 'catalog/:id',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: Catlog(id: int.parse(state.params['id']!)),
              ),
            ), */
          ]),
      GoRoute(
        path: '/main',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'main'}),
      ),
      GoRoute(
        path: '/shop',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'shop'}),
      ),
      GoRoute(
        path: '/cart',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'cart'}),
      ),
      GoRoute(
        path: '/profile',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'profile'}),
      ),
      GoRoute(
        path: '/more',
        redirect: (state) =>
            state.namedLocation('home', params: {'tab': 'more'}),
      ),
      GoRoute(
        path: '/product/:id',
        redirect: (state) => state.namedLocation(
          'product',
          params: {'tab': 'shop', 'id': state.params['id']!},
        ),
      ),
/*       GoRoute(
        path: '/catalog/:id',
        redirect: (state) => state.namedLocation(
          'catalog',
          params: {'tab': 'shop', 'id': state.params['id']!},
        ),
      ), */
    ],
    redirect: (state) {
      //print('device token ' + loginState.token);
      final splashLoc = state.namedLocation('splash');
      final splashIn = state.subloc == splashLoc;
      final welcomeLoc = state.namedLocation('welcome');
      final welcomeIn = state.subloc == welcomeLoc;
      final loginLoc = state.namedLocation('login');
      final loggingIn = state.subloc == loginLoc;
      final rootLoc = state.namedLocation('root');

      if (loginState.token == '' && !splashIn) {
        return splashLoc;
      }
      if (loginState.token != '' &&
          !(loginState.loggedIn || loginState.skipLogin) &&
          !welcomeIn) {
        return welcomeLoc;
      }
      if (loginState.loggedIn && loggingIn) {
        return rootLoc;
      }
      if (loginState.skipLogin && welcomeIn) {
        return rootLoc;
      }
      return null;
    },
  );
}
