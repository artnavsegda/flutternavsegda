import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../main.dart';
import '../login/login.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool finalScreen = false;
  int pageNumber = 0;
  final PageController _controller = PageController(viewportFraction: 0.8);

  final imageList = [
    'assets/3.0x/Illustration-Welcome.png',
    'assets/3.0x/Illustration-Push.png',
    'assets/3.0x/Illustration-Map.png',
    'assets/3.0x/Illustration-Login.png',
    'assets/3.0x/Illustration-Welcome.png',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      alignment: Alignment.centerRight,
      children: [
        Column(
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: Image.asset(
                imageList[pageNumber],
                key: ValueKey<int>(pageNumber),
                scale: 0.5,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: PageView(
                  //physics: const NeverScrollableScrollPhysics(),
                  padEnds: false,
                  controller: _controller,
                  onPageChanged: (page) {
                    if (page == 4) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainPage()));
                    }
                    setState(() {
                      pageNumber = page;
                      finalScreen = page == 3;
                    });
                  },
                  scrollDirection: Axis.vertical,
                  children: [
                    Opacity(
                        child: const Welcome(),
                        opacity: pageNumber == 0 ? 1 : 0.2),
                    Opacity(
                        child: const Push(),
                        opacity: pageNumber == 1 ? 1 : 0.2),
                    Opacity(
                        child: const Location(),
                        opacity: pageNumber == 2 ? 1 : 0.2),
                    Opacity(
                        child: const Login(),
                        opacity: pageNumber == 3 ? 1 : 0.2),
                    const SizedBox.expand()
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
                  spacing: 4.0,
                  //radius: 4.0,
                  dotWidth: 5.0,
                  dotHeight: 5.0,
                  expansionFactor: 6,
                  activeDotColor: Color(0xFFB0063A)),
              onDotClicked: (index) {}),
        ),
/*         Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 200,
            child: Container(
              color: Colors.white70,
            )), */
        Positioned(
            bottom: 20,
            left: 20,
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              firstChild: ElevatedButton(
                child: const Text('Выбрать что-нибудь вкусное'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage()));
                },
              ),
              secondChild: ElevatedButton.icon(
                onPressed: () {
                  _controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut);
                },
                label: const ImageIcon(AssetImage('assets/Icon-East.png')),
                icon: const Text("Далее"),
              ),
              crossFadeState: finalScreen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
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
Продолжайте писать эту красивую историю с нами.''',
        )
        //style: TextStyle(fontSize: 14.0, height: 1.4)),
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
      children: [
        const Text('Уведомления',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        const SizedBox(height: 20),
        const Text(
            '''Хотите быть в курсе вкусных акций и предложений? Позвольте присылать уведомления.''',
            style: TextStyle(fontSize: 14.0)),
        const SizedBox(height: 20),
        OutlinedButton(
            onPressed: () {}, child: const Text('Разрешить уведомления'))
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
      children: [
        const Text('Местоположение',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        const SizedBox(height: 20),
        const Text(
            '''А теперь ―  геолокация. Разрешите доступ, это упростит поиск адреса для доставки или самовывоза Ваших любимых пирожных.''',
            style: TextStyle(fontSize: 14.0)),
        const SizedBox(height: 20),
        OutlinedButton(
            onPressed: () {},
            child: const Text('Предоставить доступ к геоданным'))
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
      children: [
        const Text('Все возможности',
            style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
        const SizedBox(height: 20),
        const Text(
            '''Войдите в аккаунт и используйте все возможности приложения.
Копите баллы, заказывайте любимые блюда, узнавайте о новинках первыми.''',
            style: TextStyle(fontSize: 14.0)),
        const SizedBox(height: 20),
        OutlinedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: const Text('Войти или зарегистрироваться'))
      ],
    );
  }
}
