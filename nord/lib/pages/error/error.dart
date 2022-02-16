import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key? key,
    required this.reload,
  }) : super(key: key);

  final Function() reload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
/*         leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Colors.red[900],
            )), */
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
              onPressed: reload,
              child: Text('Повторить'),
            ),
          ),
        ],
      ),
    );
  }
}
