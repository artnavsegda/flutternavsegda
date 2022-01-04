import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../components/gradient_button.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта клиента'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Center(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
                      blurRadius: 20.0,
                      offset: Offset(0.0, 4.0),
                    ),
                  ],
                ),
                child: QrImage(
                  data: "1234567890",
                  size: 200.0,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                width: 264,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 8),
                            Text('Предъявите\nна кассе',
                                style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        Transform.rotate(
                            angle: pi,
                            child: Image.asset('assets/Union.png',
                                color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 32),
                    Text('+ 7 999 548 63 75',
                        style: TextStyle(
                          fontFamily: 'Forum',
                          fontSize: 34,
                          color: Colors.red[900],
                        )),
                    SizedBox(height: 10),
                    const Text(
                      'Поднесите телефон к сканеру на кассе, чтобы начислить или списать бонусы',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            GradientButton(
                onPressed: () {},
                child: const Text('Добавить карту в Google Pay')),
          ],
        ),
      ),
    );
  }
}
