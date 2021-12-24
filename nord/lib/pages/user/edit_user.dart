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
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Center(
                                child: Text(
                              'Изменение фотографии',
                            )),
                            trailing: Image.asset('assets/Icon-Close.png'),
                          ),
                          ListTile(
                            leading:
                                Image.asset('assets/Icon-Photo-Camers.png'),
                            title: Text('Запустить камеру'),
                          ),
                          ListTile(
                            leading: Image.asset('assets/Icon-List.png'),
                            title: Text('Выбрать из галереи'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 48,
                  foregroundImage: AssetImage('assets/treska.jpg'),
                ),
              ),
            ),
            SizedBox(height: 24),
            const Text(
              "Личная информация",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
            SizedBox(height: 24),
            TextField(
              decoration: const InputDecoration(labelText: "Имя"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Номер телефона"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Номер телефона"),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(labelText: "Номер телефона"),
            ),
            SizedBox(height: 24),
            const Text(
              "Другие настройки",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
            SizedBox(height: 16),
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
            SizedBox(height: 24),
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
