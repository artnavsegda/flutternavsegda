import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                context.push('/login');
              },
              child: Text('Login'),
            ),
            TextButton(
              child: Text('Skip'),
              onPressed: () {
                context.go('/main');
              },
            )
          ],
        ),
      ),
    );
  }
}
