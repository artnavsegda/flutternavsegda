import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:provider/provider.dart';

import 'password.dart';
import '../../components/sms.dart';
import 'dialog.dart';
import '../../gql.dart';
import '../../main.dart';
import '../main.dart';
import '../../components/components.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DialogPage(
      image: const AssetImage('assets/Login.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("ВОЙТИ"),
              onPressed: () => _userLogin(context),
            ),
          ),
          TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(110, 48),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainPage()),
                );
              },
              child: const Text("ПОЗЖЕ")),
        ],
      ),
    );
  }

  void _userLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return const UserLoginPage();
      },
    );
  }
}

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  bool phoneNumberIsCorrect = false;
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
            const Text("Вход",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                )),
            Container(
              margin: const EdgeInsets.only(top: 8.0),
              height: 48,
              child: TextField(
                onChanged: (value) async {
                  try {
                    await PhoneNumberUtil().parse(value);
                    setState(() {
                      phoneNumberIsCorrect = true;
                    });
                  } catch (e) {
                    setState(() {
                      phoneNumberIsCorrect = false;
                    });
                  }
                },
                controller: phoneNumberController,
                inputFormatters: [maskFormatter],
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: '+7(___) ___-__-__'),
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
            Consumer<AppModel>(builder: (context, model, child) {
              return Mutation(
                options: MutationOptions(
                  document: gql(loginClient),
                  onError: (error) {
                    //print("ERROR");
                    //print(error);
                  },
                  onCompleted: (dynamic resultData) async {
                    //(resultData);
                    if (resultData['loginClient']['result'] == 0) {
                      await model.setToken(resultData['loginClient']['token']);
                      Navigator.pop(context);
                      if (resultData['loginClient']['nextStep'] == 'PASSWORD') {
                        _enterPassword(context);
                      } else {
                        _confirmSMS(context);
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Ошибка'),
                          content:
                              Text(resultData['loginClient']['errorMessage']),
                          actions: [
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
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: isAgreed &&
                                isFamiliarized &&
                                phoneNumberIsCorrect
                            ? () async {
                                try {
                                  PhoneNumber phoneNumber =
                                      await PhoneNumberUtil()
                                          .parse(phoneNumberController.text);
                                  //print('7' + phoneNumber.nationalNumber);
                                  runMutation({
                                    'clientPhone': int.parse(
                                        '7' + phoneNumber.nationalNumber),
                                  });
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Ошибка'),
                                      content: const Text("Неправильный номер"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Text("ВОЙТИ")),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _confirmSMS(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return const ConfirmSMSPage();
      },
    );
  }

  void _enterPassword(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return const PasswordPage();
      },
    );
  }
}
