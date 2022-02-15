import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/Illustration-No-Data.png',
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Что-то пошло не так...',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
                'Возникла непредвиденная ситуация. Пожалуйста, проверьте подключение и повторите запрос.'),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Повторить'),
            ),
          ),
        ],
      ),
    );
  }
}
