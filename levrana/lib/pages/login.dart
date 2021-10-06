import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import '../gql.dart';
import '../main.dart';
import '../components.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  final TextEditingController phoneNumberController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
      mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          children: [
            Text("Вход",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                )),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              height: 48,
              child: TextField(
                controller: phoneNumberController,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: '+7(___) ___-__-__'),
              ),
            ),
            CheckboxTitle(
              title:
                  "Ознакомлен с условиями положения о защите персональных данных",
              value: isFamiliarized,
              onChanged: (newValue) => setState(() {
                isFamiliarized = newValue!;
              }),
            ),
            CheckboxTitle(
              title: "Даю свое согласие на обработку персональных данных",
              value: isAgreed,
              onChanged: (newValue) => setState(() {
                isAgreed = newValue!;
              }),
            ),
            Mutation(
              options: MutationOptions(
                document: gql(loginClient),
                onError: (error) {
                  //print("ERROR");
                  //print(error);
                },
                onCompleted: (dynamic resultData) async {
                  //(resultData);
                  if (resultData['loginClient']['result'] == 0) {
                    final prefs = await SharedPreferences.getInstance();
                    //print("loginClient token :" +
                    //    resultData['loginClient']['token']);
                    prefs.setString(
                        'token', resultData['loginClient']['token']);
                    Navigator.pop(context);
                    if (resultData['loginClient']['nextStep'] == 'PASSWORD')
                      _enterPassword(context);
                    else
                      _confirmSMS(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content:
                            Text(resultData['loginClient']['errorMessage']),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              builder: (
                RunMutation runMutation,
                QueryResult? result,
              ) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: isAgreed && isFamiliarized
                          ? () async {
                              PhoneNumber phoneNumber = await PhoneNumberUtil()
                                  .parse(phoneNumberController.text);
                              //print('7' + phoneNumber.nationalNumber);
                              runMutation({
                                'clientPhone':
                                    int.parse('7' + phoneNumber.nationalNumber),
                              });
                            }
                          : null,
                      child: Text("ВОЙТИ")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSMS(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      ),
      builder: (context) {
        return ConfirmSMSPage();
      },
    );
  }

  void _enterPassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      ),
      builder: (context) {
        return PasswordPage();
      },
    );
  }
}

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          children: [
            Text("Пароль",
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                )),
            Container(
              margin: EdgeInsets.only(top: 8.0),
              height: 48,
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Ввести пароль'),
              ),
            ),
            Mutation(
              options: MutationOptions(
                  document: gql(checkPassword),
                  update: (cache, result) {
                    if (result!.hasException) {
                      //print(result.exception);
                    } else {
                      return cache;
                    }
                  },
                  onError: (error) {
                    //print("ERROR");
                    //print(error!.graphqlErrors[0].message);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Ошибка'),
                        content: Text(error!.graphqlErrors[0].message),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  onCompleted: (dynamic resultData) async {
                    //print(resultData);
                    if (resultData != null) {
                      if (resultData['checkClient']['result'] == 0) {
                        final prefs = await SharedPreferences.getInstance();
                        //print("checkClient token :" +
                        //    resultData['checkClient']['token']);
                        prefs.setString(
                            'token', resultData['checkClient']['token']);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ошибка'),
                            content:
                                Text(resultData['checkClient']['errorMessage']),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }),
              builder: (
                RunMutation runMutation,
                QueryResult? result,
              ) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity,
                            48), // double.infinity is the width and 30 is the height
                      ),
                      child:
                          Text("ПОДТВЕРДИТЬ", style: TextStyle(fontSize: 16.0)),
                      onPressed: () {
                        runMutation({
                          'password': passwordController.text,
                        });
                      }),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity,
                        48), // double.infinity is the width and 30 is the height
                  ),
                  onPressed: () {},
                  child: Text("ЗАБЫЛ ПАРОЛЬ",
                      style: GoogleFonts.montserrat(fontSize: 16))),
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmSMSPage extends StatefulWidget {
  const ConfirmSMSPage({
    Key? key,
  }) : super(key: key);

  @override
  _ConfirmSMSPageState createState() => _ConfirmSMSPageState();
}

class _ConfirmSMSPageState extends State<ConfirmSMSPage> {
  int smsTimeout = 30;

  final TextEditingController smsCodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    smsCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    repeatSMS();
    super.initState();
  }

  void repeatSMS() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (smsTimeout == 0) {
        timer.cancel();
      } else {
        setState(() {
          smsTimeout--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(children: [
          Text("Код",
              style: GoogleFonts.montserrat(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              )),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            height: 48,
            child: TextField(
              controller: smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: '12345'),
            ),
          ),
          Mutation(
            options: MutationOptions(
                document: gql(checkClient),
                onError: (error) {
                  //print("ERROR");
                  //print(error!.graphqlErrors[0].message);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Ошибка'),
                      content: Text(error!.graphqlErrors[0].message),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                onCompleted: (dynamic resultData) async {
                  //print(resultData);
                  if (resultData != null) {
                    if (resultData['checkClient']['result'] == 0) {
                      final prefs = await SharedPreferences.getInstance();
                      //print("checkClient token :" +
                      //    resultData['checkClient']['token']);
                      prefs.setString(
                          'token', resultData['checkClient']['token']);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Ошибка'),
                          content:
                              Text(resultData['checkClient']['errorMessage']),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }),
            builder: (
              RunMutation runMutation,
              QueryResult? result,
            ) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          48), // double.infinity is the width and 30 is the height
                    ),
                    child:
                        Text("ПОДТВЕРДИТЬ", style: TextStyle(fontSize: 16.0)),
                    onPressed: () {
                      runMutation({
                        'code': smsCodeController.text,
                      });
                    }),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: TextButton(
                style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(double.infinity, 48.0)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            side: BorderSide(color: Colors.green)))),
                onPressed: smsTimeout == 0 ? repeatSMS : null,
                child: Text(
                    "ПОВТОРИТЬ" +
                        (smsTimeout == 0 ? "" : " ($smsTimeout) СЕК."),
                    style: GoogleFonts.montserrat(fontSize: 16))),
          )
        ]),
      ),
    );
  }
}

class CheckboxTitle extends StatelessWidget {
  const CheckboxTitle(
      {Key? key, this.title = "", required this.value, required this.onChanged})
      : super(key: key);

  final String title;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 24.0,
            width: 32.0,
            child: LevranaCheckbox(
              value: value,
              onChanged: onChanged,
            ),
          ),
          Flexible(
            child: InkWell(
                onTap: () {
                  onChanged(!value);
                },
                child:
                    Text(title, style: GoogleFonts.montserrat(fontSize: 14))),
          )
        ],
      ),
    );
  }
}
