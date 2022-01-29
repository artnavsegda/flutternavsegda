import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../main.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({Key? key, this.phone}) : super(key: key);

  final String? phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/Icon-West.png')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Введите\nкод подтверждения',
                style: TextStyle(fontFamily: 'Forum', fontSize: 24.0)),
            const SizedBox(height: 9),
            Text('Код подтверждения был отправлен на номер:\n$phone'),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: "Код подтверждения"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  context.go('/main');
                },
                child: const Text('Подтвердить')),
            const SizedBox(height: 8),
            TextButton(
                onPressed: () {}, child: const Text('Запросить новый код')),
          ],
        ),
      ),
    );
  }
}
