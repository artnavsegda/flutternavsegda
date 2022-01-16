import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_state.dart';
import '../pages/login.dart';
import '../pages/welcome.dart';

class LevranaRouter {
  final LoginState loginState;
  LevranaRouter(this.loginState);
  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        redirect: (state) =>
            // TODO: Change to Home Route
            state.namedLocation('login'),
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
    ],
    redirect: (state) {
      //print('device token ' + loginState.token);
      final welcomeLoc = state.namedLocation('welcome');
      final welcomeIn = state.subloc == welcomeLoc;
      final loginLoc = state.namedLocation('login');
      final loggingIn = state.subloc == loginLoc;
      if (loginState.token == '' && !welcomeIn) {
        return state.namedLocation('welcome');
      }
      if (loginState.token != '' && !loggingIn) {
        return state.namedLocation('login');
      }
      return null;
    },
  );
}
