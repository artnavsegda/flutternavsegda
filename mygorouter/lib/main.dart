import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';

import 'login_state.dart';
import 'router/routes.dart';

Future<void> main() async {
  await initHiveForFlutter();
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
      child: Consumer<LoginState>(
        builder: (BuildContext context, model, child) {
          final router =
              Provider.of<LevranaRouter>(context, listen: false).router;
          return GraphQLProvider(
            client: ValueNotifier(
              GraphQLClient(
                link: AuthLink(getToken: () => 'Bearer ' + model.token).concat(
                  HttpLink(
                    'https://demo.cyberiasoft.com/levranaservice/graphql',
                  ),
                ),
                cache: GraphQLCache(store: HiveStore()),
              ),
            ),
            child: MaterialApp.router(
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
              debugShowCheckedModeBanner: false,
              title: 'Levrana App',
              theme: ThemeData(
                primarySwatch: Colors.red,
              ),
            ),
          );
        },
      ),
    );
  }
}
