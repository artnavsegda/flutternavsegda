import 'package:flutter/material.dart';

class Unregistered extends StatelessWidget {
  const Unregistered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/Illustration-Login.png'),
        const Text('Расплачивайтесь баллами, покупайе с удовольствием'),
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
        ElevatedButton(
            onPressed: () {}, child: const Text('Войти или зарегистрироваться'))
      ],
    );
  }
}
