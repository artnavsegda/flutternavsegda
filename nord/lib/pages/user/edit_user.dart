import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/gradient_button.dart';

class EditUser extends StatelessWidget {
  const EditUser({Key? key}) : super(key: key);

  void _showCameraModal(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
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
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Image.asset('assets/Icon-Photo-Camers.png'),
              title: const Text('Запустить камеру'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset('assets/Icon-List.png'),
              title: const Text('Выбрать из галереи'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => _showCameraModal(context),
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
                  Text(
                    "Личная информация",
                    style: Theme.of(context).textTheme.headlineSmall,
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
                  Text('Неподтвержденный адрес Email. Подтвердить'),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: "Номер телефона"),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(labelText: "Номер телефона"),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Другие настройки",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Сохранить")),
            )
          ],
        ),
      ),
    );
  }
}
