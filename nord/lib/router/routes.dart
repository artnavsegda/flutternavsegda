import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../login_state.dart';
import '../intro.dart';
import '../pages/login/login.dart';
import '../pages/login/password.dart';
import '../pages/login/sms.dart';
import '../pages/onboarding/onboarding.dart';
import '../pages/main.dart';
import '../pages/product/product.dart';
import '../pages/action/action.dart';
import '../pages/user/edit_user.dart';
import '../pages/shopping/pay.dart';
import '../pages/shopping/success.dart';
import '../pages/shopping/registration.dart';

class NordRouter {
  final LoginState loginState;
  NordRouter(this.loginState);
  late final router = GoRouter(
    //refreshListenable: loginState,
    //debugLogDiagnostics: true,
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        name: 'root',
        path: '/',
        redirect: (state) => state.namedLocation('home', params: {'tab': '0'}),
      ),
      GoRoute(
        name: 'welcome',
        path: '/welcome',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const Onboarding(),
        ),
      ),
      GoRoute(
        name: 'pay',
        path: '/pay',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const PayPage(),
        ),
      ),
      GoRoute(
        name: 'registration',
        path: '/registration',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const RegistrationPage(),
        ),
      ),
      GoRoute(
        name: 'success',
        path: '/success',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const SuccessPage(),
        ),
      ),
      GoRoute(
        name: 'splash',
        path: '/splash',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const IntroPage(),
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
        name: 'password',
        path: '/password',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const PasswordPage(),
        ),
      ),
      GoRoute(
        name: 'sms',
        path: '/sms/:phone',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: SmsPage(phone: state.params['phone']),
        ),
      ),
      GoRoute(
          name: 'home',
          path: '/home/:tab(0|1|2|3|4)',
          pageBuilder: (context, state) {
            final tab = state.params['tab']!;
            return MaterialPage<void>(
              key: state.pageKey,
              child: MainPage(tab: tab),
            );
          },
          routes: [
            GoRoute(
              name: 'product',
              path: 'product/:id',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ProductPage(id: int.parse(state.params['id']!)),
              ),
            ),
            GoRoute(
              name: 'action',
              path: 'action/:id',
              pageBuilder: (context, state) => MaterialPage<void>(
                key: state.pageKey,
                child: ActionPage(id: int.parse(state.params['id']!)),
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
        redirect: (state) => state.namedLocation('home', params: {'tab': '0'}),
      ),
      GoRoute(
        path: '/shop',
        redirect: (state) => state.namedLocation('home', params: {'tab': '1'}),
      ),
      GoRoute(
        path: '/cart',
        redirect: (state) => state.namedLocation('home', params: {'tab': '2'}),
      ),
      GoRoute(
        path: '/profile',
        redirect: (state) => state.namedLocation('home', params: {'tab': '3'}),
      ),
      GoRoute(
        path: '/more',
        redirect: (state) => state.namedLocation('home', params: {'tab': '4'}),
      ),
      GoRoute(
        path: '/product/:id',
        redirect: (state) => state.namedLocation(
          'product',
          params: {'tab': '1', 'id': state.params['id']!},
        ),
      ),
      GoRoute(
        path: '/action/:id',
        redirect: (state) => state.namedLocation(
          'product',
          params: {'tab': '0', 'id': state.params['id']!},
        ),
      ),
/*       GoRoute(
        path: '/catalog/:id',
        redirect: (state) => state.namedLocation(
          'catalog',
          params: {'tab': 'shop', 'id': state.params['id']!},
        ),
      ), */
/*       GoRoute(
        name: 'editProfile',
        path: '/editProfile',
        pageBuilder: (context, state) => MaterialPage<void>(
          key: state.pageKey,
          child: const EditUser(),
        ),
      ), */
    ],
    redirect: (state) {
      final splashLoc = state.namedLocation('splash');
      final splashIn = state.subloc == splashLoc;

      if (loginState.token == '' && !splashIn) {
        return splashLoc;
      }
      return null;
    },
  );
}
