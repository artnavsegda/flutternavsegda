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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView(
                  //physics: const NeverScrollableScrollPhysics(),
                  padEnds: false,
                  controller: _controller,
                  onPageChanged: (pageNumber) {
                    print(pageNumber);
                  },
                  scrollDirection: Axis.vertical,
                  children: const [
                    Welcome(),
                    Push(),
                    Location(),
                    Login(),
                    SizedBox.expand()
                  ],
                ),
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
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
            child: Container(
              color: Colors.white70,
            )),
        Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                _controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut);
              },
              label: ImageIcon(AssetImage('assets/Icon East.png')),
              icon: const Text("Далее"),
            ))
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
        Text('Добро пожаловать!',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        SizedBox(height: 20),
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
        Text('Уведомления',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        SizedBox(height: 20),
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
        Text('Местоположение',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        SizedBox(height: 20),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Все возможности',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        SizedBox(height: 20),
        Text('''Войдите в аккаунт и используйте все возможности приложения.
Копите баллы, заказывайте любимые блюда, узнавайте о новинках первыми.'''),
      ],
    );
  }
}
