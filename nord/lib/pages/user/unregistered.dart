import 'package:flutter/material.dart';

class Unregistered extends StatelessWidget {
  const Unregistered({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/Illustration Login.png'),
        const Text('Расплачивайтесь баллами, покупайе с удовольствием'),
        ListTile(
          title: const Text("5% от каждой покупки на бонусный счёт"),
          leading: Image.asset('assets/Icon Present.png'),
        ),
        ListTile(
          title: const Text("Оплачивайте до 20% от покупок бонуса"),
          leading: Image.asset('assets/Icon Present.png'),
        ),
        ListTile(
          title: const Text("Специальные предложения, подарки и акции"),
          leading: Image.asset('assets/Icon Present.png'),
        ),
        ElevatedButton(
            onPressed: () {}, child: const Text('Войти или зарегистрироваться'))
      ],
    );
  }
}
