import 'package:flutter/material.dart';

class EditUser extends StatelessWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CircleAvatar(),
            ),
            const Text("Личная информация"),
            const Text("Другие настройки"),
            SwitchListTile(
              title: const Text('Отказаться от бумажных чеков'),
              value: false,
              onChanged: (newVal) {},
            ),
            SwitchListTile(
              title: const Text('Получать push-уведомления'),
              value: false,
              onChanged: (newVal) {},
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Сохранить"))
          ],
        ),
      ),
    );
  }
}
