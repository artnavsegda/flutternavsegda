import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset('assets/Illustration-No-Data.png'),
          Text('Что-то пошло не так...'),
          Text(
              'Возникла непредвиденная ситуация. Пожалуйста, проверьте подключение и повторите запрос.'),
          ElevatedButton(
            onPressed: () {},
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
