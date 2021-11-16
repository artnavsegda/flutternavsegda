import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = PageController(viewportFraction: 0.7);

    return Scaffold(
        body: Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            Image.asset('assets/Illustration Welcome.png'),
            Expanded(
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.vertical,
                children: const [
                  Welcome(),
                  Push(),
                  Location(),
                  Login(),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SmoothPageIndicator(
              axisDirection: Axis.vertical,
              controller: _controller,
              count: 4,
              effect: const ExpandingDotsEffect(
                  //spacing: 8.0,
                  //radius: 4.0,
                  dotWidth: 8.0,
                  dotHeight: 8.0,
                  expansionFactor: 5,
                  activeDotColor: Color(0xFFB0063A)),
              onDotClicked: (index) {}),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(onPressed: () {}, child: Text("Далее")))
      ],
    ));
  }
}

class Welcome extends StatelessWidget {
  const Welcome({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
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
      children: const [
        Text('Все возможности'),
        Text('''Войдите в аккаунт и используйте все возможности приложения.
Копите баллы, заказывайте любимые блюда, узнавайте о новинках первыми.'''),
      ],
    );
  }
}
