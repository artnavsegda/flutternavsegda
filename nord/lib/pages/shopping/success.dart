import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset(
          'assets/Illustration-Successful-Express-Order.png',
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Ваш заказ оформлен.\nУже собираем и упаковываем!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RichText(
            text: TextSpan(
                text:
                    'Статус вашего заказа вы можете отследить, перейдя к списку ваших покупок в ',
                style: TextStyle(
                    fontFamily: 'Noto Sans',
                    fontSize: 14,
                    color: Color(0xFF1D242C)),
                children: [
                  TextSpan(
                      text: 'личном кабинете',
                      style: TextStyle(color: Color(0xFFCD0643)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.go('/orders')),
                  TextSpan(
                    text: ' ',
                  )
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            child: Text('Вернуться на главную'),
            onPressed: () {
              context.go('/main');
            },
          ),
        ),
      ],
    ));
  }
}
