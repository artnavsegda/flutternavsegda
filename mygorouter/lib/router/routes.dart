import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_state.dart';
import '../pages/login.dart';
import '../pages/welcome.dart';
import '../pages/home.dart';

class LevranaRouter {
  final LoginState loginState;
  LevranaRouter(this.loginState);
  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: false,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        redirect: (state) => state.namedLocation('home'),
      ),
      GoRoute(
        name: 'welcome',
        path: '/welcome',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const WelcomePage(),
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
        path: '/home',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
    ],
    redirect: (state) {
      //print('device token ' + loginState.token);
      final welcomeLoc = state.namedLocation('welcome');
      final welcomeIn = state.subloc == welcomeLoc;
      final loginLoc = state.namedLocation('login');
      final loggingIn = state.subloc == loginLoc;
      final rootLoc = state.namedLocation('root');

      if (loginState.token == '' && !welcomeIn) {
        return welcomeLoc;
      }
      if (loginState.token != '' && !loggingIn) {
        return loginLoc;
      }
      if (loginState.loggedIn && loggingIn) {
        return rootLoc;
      }
      return null;
    },
  );
}
