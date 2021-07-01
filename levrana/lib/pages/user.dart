import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog.dart';

const String getClientInfo = r'''
query getClientInfo {
  getClientInfo {
    clientGUID,
    name,
    phone,
    dateOfBirth,
    gender,
    eMail,
    confirmedPhone,
    confirmedEMail
    isPassword,
    points,
    picture,
    codeInviteFriend
  }
}
''';

const String editClient = r'''
mutation editClient($clientGUID: String!, $name: String!) {
  editClient(clientInfo: { clientGUID: $clientGUID, name: $name }) {
    result
  }
}
''';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Image(
                image: AssetImage('assets/ic-24/icon-24-edit-profile.png')),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditUserPage()),
              );
            },
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Профиль", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/Личный кабинет.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          ListView(
            children: [
              ListTile(
                  title: Text("Михаил Сунцов",
                      style: GoogleFonts.montserrat(fontSize: 28)),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        AssetImage('assets/ic-24/icon-24-gift.png'),
                  )),
              Container(
                child: Column(
                  children: [
                    Text("Доступно бонусов"),
                    Text("943"),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Пригласить друга")),
                    ElevatedButton(
                        onPressed: () {}, child: Text("Подарить бонусы")),
                  ],
                ),
              ),
              ListTile(
                title: Text("Подарки"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-gift.png')),
              ),
              ListTile(
                title: Text("Активировать промокод"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-promo.png')),
              ),
              ListTile(
                title: Text("История заказов"),
                leading: Image(
                    image: AssetImage('assets/ic-24/icon-24-history.png')),
              ),
              ListTile(
                title: Text("Адреса доставки"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-adress.png')),
              ),
              ListTile(
                title: Text("Смена пароля"),
                leading:
                    Image(image: AssetImage('assets/ic-24/icon-24-pass.png')),
              ),
              GraphQLConsumer(builder: (GraphQLClient client) {
                return ListTile(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('token', '');
                    client.cache.store.reset(); // empty the hash map
                    //await client.cache.save();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Welcome()),
                    );
                  },
                  title: Text("Выйти"),
                  leading:
                      Image(image: AssetImage('assets/ic-24/icon-24-exit.png')),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class EditUserPage extends StatefulWidget {
  const EditUserPage({Key? key}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Редактирование профиля",
            style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image(
                image: AssetImage(
                    'assets/Личный кабинет • Редактирование профиля.png')),
            Column(
              children: [
                SizedBox(height: 100.0),
                CircleAvatar(
                  radius: 86,
                  backgroundImage: AssetImage('assets/ic-24/icon-24-gift.png'),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Query(
                      options: QueryOptions(document: gql(getClientInfo)),
                      builder: (result, {fetchMore, refetch}) {
                        nameController.text =
                            result.data!['getClientInfo']['name'] ?? "";

                        return Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                  controller: nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите имя';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Имя')),
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'E-mail')),
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Телефон')),
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Дата рождения')),
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'Пол')),
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Размер одежды')),
                              TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Размер обуви')),
                              SizedBox(
                                height: 32,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () {
                                      print("Magic !");
                                      if (_formKey.currentState!.validate()) {
                                        print(nameController.text);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text('Processing Data')));
                                      }
                                    },
                                    child: Text("Сохранить")),
                              )
                            ],
                          ),
                        );

                        return Column(
                          children: [
                            Text(result.data!['getClientInfo']['name'] ?? ""),
                            Text(result.data!['getClientInfo']['phone']
                                .toString()),
                            Text(result.data!['getClientInfo']['dateOfBirth'] ??
                                ""),
                            Text(result.data!['getClientInfo']['gender'] ?? ""),
                            Text(result.data!['getClientInfo']['eMail'] ?? ""),
                            Text(result.data!['getClientInfo']['confirmedPhone']
                                .toString()),
                            Text(result.data!['getClientInfo']['confirmedEMail']
                                .toString()),
                            Text(result.data!['getClientInfo']['isPassword']
                                .toString()),
                            Text(result.data!['getClientInfo']['points']
                                .toString()),
                            Text(
                                result.data!['getClientInfo']['picture'] ?? ""),
                            Text(result.data!['getClientInfo']
                                    ['codeInviteFriend'] ??
                                ""),
                          ],
                        );
                      }),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
