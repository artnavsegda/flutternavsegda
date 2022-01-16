import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'login_state.dart';
import 'router/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = LoginState(await SharedPreferences.getInstance());
  state.checkLoggedIn();
  runApp(LevranaApp(loginState: state));
}

class LevranaApp extends StatelessWidget {
  final LoginState loginState;

  const LevranaApp({Key? key, required this.loginState}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          lazy: false,
          create: (BuildContext createContext) => loginState,
        ),
        Provider<LevranaRouter>(
          lazy: false,
          create: (BuildContext createContext) => LevranaRouter(loginState),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final router =
              Provider.of<LevranaRouter>(context, listen: false).router;
          return MaterialApp.router(
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            debugShowCheckedModeBanner: false,
            title: 'Levrana App',
            theme: ThemeData(
              primarySwatch: Colors.green,
            ),
          );
        },
      ),
    );
  }
}
