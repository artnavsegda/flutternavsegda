import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

import 'dialog.dart';
import 'editUser.dart';
import 'bonus.dart';

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

const String promocodeActivation = r'''
mutation promocodeActivation($promoCode: String)
{
  promocodeActivation(promoCode: $promoCode) {
    result
    errorMessage
  }
}
''';

const String setPassword = r'''
mutation setPassword($password: String)
{
  setPassword(password: $password)
  {
    result
    errorMessage
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
            return Center(
                child: ElevatedButton(
              child: Text("Войти в профиль"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ));
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
                  image: AssetImage('assets/UserPage.png'),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              result.data!['getClientInfo']['picture']),
                        ),
                        Text(result.data!['getClientInfo']['name'] ?? "",
                            style: GoogleFonts.montserrat(fontSize: 28))
                      ],
                    ),
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
                          OutlinedButton(
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      Size(223.0, 36.0)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              onPressed: () {},
                              child: Text("ПРИГЛАСИТЬ ДРУГА",
                                  style: TextStyle(fontSize: 16.0))),
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: const Radius.circular(16.0)),
                                  ),
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return TransferBonusPage(
                                        maxAmount: result.data!['getClientInfo']
                                            ['points']);
                                  },
                                );
                              },
                              child: Text("ПОДАРИТЬ БОНУСЫ",
                                  style: TextStyle(fontSize: 16.0))),
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
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(16.0)),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Promocode(),
                            );
                          },
                        );
                      },
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
                      onTap: () {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(16.0)),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return SetPasswordPage();
                          },
                        );
                      },
                      title: Text("Смена пароля"),
                      leading: Image(
                          image: AssetImage('assets/ic-24/icon-24-pass.png')),
                    ),
                    GraphQLConsumer(builder: (GraphQLClient client) {
                      return ListTile(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.remove('token');
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

class Promocode extends StatefulWidget {
  const Promocode({
    Key? key,
  }) : super(key: key);

  @override
  _PromocodeState createState() => _PromocodeState();
}

class _PromocodeState extends State<Promocode> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Wrap(
        runSpacing: 8.0,
        children: [
          Text('Промокод',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              )),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              labelText: "Введите промокод",
            ),
          ),
          Mutation(
              options: MutationOptions(
                document: gql(promocodeActivation),
                onCompleted: (resultData) {
                  print(resultData);
                  Navigator.pop(context);
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: const Text('АКТИВИРОВАТЬ ПРОМОКОД'),
                  onPressed: () {
                    runMutation({
                      'promoCode': textController.text,
                    });
                  },
                );
              })
        ],
      ),
    );
  }
}

class SetPasswordPage extends StatefulWidget {
  const SetPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool _isPassValid = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    void handleChange() {
      if (passwordController.text.length > 0)
        setState(() {
          _isPassValid = passwordController.text == confirmController.text;
        });
    }

    passwordController.addListener(handleChange);
    confirmController.addListener(handleChange);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Wrap(
        runSpacing: 8.0,
        children: <Widget>[
          Text('Смена пароля',
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              )),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Введите пароль",
            ),
          ),
          TextField(
            controller: confirmController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Подтвердите пароль",
            ),
          ),
          Mutation(
              options: MutationOptions(
                document: gql(setPassword),
                onCompleted: (resultData) {
                  print(resultData);
                  Navigator.pop(context);
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: const Text('УСТАНОВИТЬ ПАРОЛЬ'),
                  onPressed: _isPassValid
                      ? () => runMutation({'password': passwordController.text})
                      : null,
                );
              })
        ],
      ),
    );
  }
}
