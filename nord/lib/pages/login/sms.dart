import 'package:flutter/material.dart';
import '../main.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({Key? key}) : super(key: key);

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
            const Text(
                'Код подтверждения был отправлен на номер:\n+7 999 102-17-32'),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: "Код подтверждения"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainPage()));
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
