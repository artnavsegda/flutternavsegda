import 'package:flutter/material.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Welcome());
  }
}

class Welcome extends StatelessWidget {
  const Welcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Добро пожаловать!'),
        Text(
            '''С Вами легендарная кондитерская Петербурга. C 1903 года мы создаем торты и пирожные, храним традиции талантливых советских технологов, чтобы сделать Ваш день приятней.
Мы движемся вперед, разработали удобную бонусную систему, обновили мобильное приложение, а заодно и сайт.
Продолжайте писать эту красивую историю с нами.'''),
      ],
    );
  }
}

class Push extends StatelessWidget {
  const Push({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Уведомления'),
        Text(
            '''Хотите быть в курсе вкусных акций и предложений? Позвольте присылать уведомления.'''),
      ],
    );
  }
}

class Location extends StatelessWidget {
  const Location({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Местоположение'),
        Text(
            '''А теперь ―  геолокация. Разрешите доступ, это упростит поиск адреса для доставки или самовывоза Ваших любимых пирожных.'''),
      ],
    );
  }
}

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Все возможности'),
        Text('''Войдите в аккаунт и используйте все возможности приложения.
Копите баллы, заказывайте любимые блюда, узнавайте о новинках первыми.'''),
      ],
    );
  }
}
