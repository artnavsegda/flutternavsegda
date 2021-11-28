import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrPage extends StatelessWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Карта клиента'),
      ),
      body: Column(
        children: [
          QrImage(
            data: "1234567890",
            size: 200.0,
          ),
          const Text('Предъявите на кассе'),
          const Text('+ 7 999 548 63 75'),
          const Text(
              'Поднесите телефон к сканеру на кассе, чтобы начислить или списать бонусы'),
          ElevatedButton(
              onPressed: () {},
              child: const Text('Добавить карту в Google Pay')),
        ],
      ),
    );
  }
}
