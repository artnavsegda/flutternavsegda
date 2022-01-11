import 'package:flutter/material.dart';

class EditUser extends StatelessWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Профиль"),
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
                            title: const Center(
                                child: Text(
                              'Изменение фотографии',
                            )),
                            trailing: Image.asset('assets/Icon-Close.png'),
                          ),
                          ListTile(
                            leading:
                                Image.asset('assets/Icon-Photo-Camers.png'),
                            title: const Text('Запустить камеру'),
                          ),
                          ListTile(
                            leading: Image.asset('assets/Icon-List.png'),
                            title: const Text('Выбрать из галереи'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      foregroundImage: AssetImage('assets/treska.jpg'),
                    ),
                    Image.asset(
                      'assets/Icon-Photo-Camers.png',
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Личная информация",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: "Имя"),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Номер телефона"),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Номер телефона"),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: "Номер телефона"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Другие настройки",
              style: TextStyle(fontFamily: 'Forum', fontSize: 24),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
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
