import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../login_state.dart';
import '../gql.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text('Login'),
            ),
            TextButton(
              child: Text('Skip'),
              onPressed: () {
                Provider.of<LoginState>(context, listen: false).skipLogin =
                    true;
              },
            )
          ],
        ),
      ),
    );
  }
}
