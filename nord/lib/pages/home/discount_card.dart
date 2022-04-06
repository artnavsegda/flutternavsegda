import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../sever_metropol_icons.dart';

import 'qr.dart';
import '../loyalty/loyalty.dart';

class CardNotLoggedIn extends StatelessWidget {
  const CardNotLoggedIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: 20.0,
              offset: Offset(0.0, 6.0),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Color(0xffCD0643), Color(0xffB0063A)])),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: 16,
              child: Image.asset('assets/Logo-Blue.png'),
            ),
            Positioned(
              left: 16,
              top: 40,
              child: Image.asset('assets/Logo-Red.png'),
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Image.asset('assets/Special-Icon-QR-Code-Scanner.png'),
            ),
            Positioned(
              bottom: 8,
              left: 16,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                child: const Text('Войти'),
                onPressed: () {
                  context.push('/login');
                },
              ),
            ),
            Positioned(
              bottom: 60,
              left: 32,
              child: Image.asset('assets/Union.png'),
            ),
            const Positioned(
              bottom: 87,
              left: 85,
              child: Text(
                'Сюрпризы ждут вас!',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CardLoggedIn extends StatelessWidget {
  const CardLoggedIn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: 20.0,
              offset: Offset(0.0, 6.0),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
          gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[Color(0xff0057B8), Color(0xff0A478B)])),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: 16,
                top: 16,
                child: Image.asset('assets/Logo-Blue.png'),
              ),
              Positioned(
                left: 16,
                top: 40,
                child: Image.asset('assets/Logo-Red.png'),
              ),
/*                 Positioned(
                right: 16,
                top: 16,
                child: Image.asset('assets/Special-Icon-QR-Code-Scanner.png'),
              ),
              Positioned(
                top: 88,
                right: 43,
                child: Transform.rotate(
                    angle: pi, child: Image.asset('assets/Union.png')),
              ),
              const Positioned(
                top: 113,
                right: 97,
                child: Text(
                  'Ваша карта',
                  style: TextStyle(color: Colors.white),
                ),
              ), */
              const Positioned(
                bottom: 64,
                left: 16,
                child: Text(
                  'У вас',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 34,
                left: 16,
                child: Text(
                  '120 бонусов',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                child: Text(
                  '5% начисление',
                  style: TextStyle(color: Color(0xB2FFFFFF), fontSize: 12),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white),
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QrPage()));
                  },
                  child: Text('QR-код'),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoyaltyPage()));
                  },
                  icon: Icon(
                    SeverMetropol.Icon_Info,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
