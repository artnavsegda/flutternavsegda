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
mutation editClient($clientGUID: String!, $name: String, $eMail: String) {
  editClient(clientInfo: { clientGUID: $clientGUID, name: $name, eMail: $eMail }) {
    result
  }
}
''';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(document: gql(getClientInfo)),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return Center(child: Text("Профиль пользователя недоступен"));
            return Center(child: Text(result.exception.toString()));
          }

          if (result.isLoading && result.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: const Image(
                      image:
                          AssetImage('assets/ic-24/icon-24-edit-profile.png')),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditUserPage()),
                    );
                    refetch!();
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
                        title: Text(result.data!['getClientInfo']['name'],
                            style: GoogleFonts.montserrat(fontSize: 28)),
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/ic-24/icon-24-gift.png'),
                        )),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.0525),
                            blurRadius: 3.13,
                            offset: Offset(0.0, 2.19),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.0775),
                            blurRadius: 10.5,
                            offset: Offset(0.0, 7.37),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.13),
                            blurRadius: 47,
                            offset: Offset(0.0, 33),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("Доступно бонусов"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  result.data!['getClientInfo']['points']
                                      .toString(),
                                  style: GoogleFonts.montserrat(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w700)),
                              Image(
                                  image: AssetImage(
                                      'assets/ic-24/icon-24-bonus.png'))
                            ],
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(223.0, 36.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.green)))),
                              onPressed: () {},
                              child: Text("ПРИГЛАСИТЬ ДРУГА",
                                  style: GoogleFonts.montserrat(fontSize: 16))),
                          ElevatedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(223.0, 36.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("Подарить бонусы"),
                                          Text("Укажите количество бонусов"),
                                          Text("По номеру телефона"),
                                          Text("По QR коду"),
                                          Text("Введите телефон"),
                                          ElevatedButton(
                                              onPressed: () {},
                                              child: Text("ВВЕДИТЕ ПОЛУЧАТЕЛЯ"))
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("ПОДАРИТЬ БОНУСЫ",
                                  style: GoogleFonts.montserrat(fontSize: 16))),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text("Подарки"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-gift.png')),
                    ),
                    ListTile(
                      title: Text("Активировать промокод"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-promo.png')),
                    ),
                    ListTile(
                      title: Text("История заказов"),
                      leading: Image(
                          image:
                              AssetImage('assets/ic-24/icon-24-history.png')),
                    ),
                    ListTile(
                      title: Text("Адреса доставки"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-adress.png')),
                    ),
                    ListTile(
                      title: Text("Смена пароля"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-pass.png')),
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
                        leading: Image(
                            image: AssetImage('assets/ic-24/icon-24-exit.png')),
                      );
                    }),
                  ],
                )
              ],
            ),
          );
        });
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
  final emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    emailController.dispose();
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
                        if (result.isLoading && result.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        nameController.text =
                            result.data!['getClientInfo']['name'] ?? "";

                        emailController.text =
                            result.data!['getClientInfo']['eMail'] ?? "";

                        var clientGUID =
                            result.data!['getClientInfo']['clientGUID'];

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
                                  controller: emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Введите E-Mail';
                                    }
                                    return null;
                                  },
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
                                child: Mutation(
                                  options: MutationOptions(
                                    document: gql(editClient),
                                    onCompleted: (resultData) {
                                      print(resultData);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  builder: (runMutation, result) {
                                    return ElevatedButton(
                                        onPressed: () {
                                          print("Magic !");
                                          if (_formKey.currentState!
                                              .validate()) {
                                            print(nameController.text);
                                            runMutation({
                                              'clientGUID': clientGUID,
                                              'name': nameController.text,
                                              'eMail': emailController.text,
                                            });
                                            //Navigator.pop(context);
                                          }
                                        },
                                        child: Text("СОХРАНИТЬ",
                                            style: GoogleFonts.montserrat(
                                                fontSize: 16)));
                                  },
                                ),
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
