import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../components/gradient_button.dart';

class Unregistered extends StatelessWidget {
  const Unregistered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/Illustration-Login.png'),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Text('Расплачивайтесь баллами, покупайе с удовольствием',
              style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        ),
        ListTile(
          title: const Text("5% от каждой покупки на бонусный счёт"),
          leading: Image.asset('assets/Illustration-Colored-Bonuses.png'),
        ),
        ListTile(
          title: const Text("Оплачивайте до 20% от покупок бонуса"),
          leading: Image.asset('assets/Illustration-Colored-Discount.png'),
        ),
        ListTile(
          title: const Text("Специальные предложения, подарки и акции"),
          leading: Image.asset('assets/Illustration-Colored-Gift.png'),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GradientButton(
              onPressed: () {
                context.push('/login');
              },
              child: const Text('Войти или зарегистрироваться')),
        )
      ],
    );
  }
}
