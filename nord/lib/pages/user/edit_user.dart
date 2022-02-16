import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nord/sever_metropol_icons.dart';

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
              trailing: Icon(
                SeverMetropol.Icon_Close,
                color: Colors.red[900],
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(
                SeverMetropol.Icon_Photo_Camers,
                color: Colors.red[900],
              ),
              title: const Text('Запустить камеру'),
              onTap: () async {
                final pickedFile =
                    await _picker.pickImage(source: ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                SeverMetropol.Icon_List,
                color: Colors.red[900],
              ),
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
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Colors.red[900],
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Имя",
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            SeverMetropol.Icon_Clear,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Номер телефона",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              SeverMetropol.Icon_Clear,
                              size: 24.0,
                            ),
                          )),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: "Email",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              SeverMetropol.Icon_Clear,
                              size: 24.0,
                            ),
                          )),
                    ),
                    Text('Неподтвержденный адрес Email. Подтвердить'),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Дата рождения",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              SeverMetropol.Icon_Calendar_Today,
                              size: 24.0,
                            ),
                          )),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                          labelText: "Пол",
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              SeverMetropol.Icon_Expand_More,
                              size: 24.0,
                              color: Colors.red[900],
                            ),
                          )),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Другие настройки",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
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
