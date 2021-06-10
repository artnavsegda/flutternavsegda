import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog.dart';
import '../main.dart';

const String loginClient = r'''
mutation loginClient($clientPhone: Long!) {
  loginClient(clientPhone: $clientPhone) {
    result
    errorMessage
    clientGUID
    token
    nextStep
  }
}
''';

const String checkClient = r'''
mutation checkClient($code: String!){
  checkClient(checkUser: {step: SMS_CONFIRMED_PHONE, code: $code}) {
    result
    errorMessage
    token
  }
}
''';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController smsCodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    phoneNumberController.dispose();
    smsCodeController.dispose();
    super.dispose();
  }

  void _userLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: const Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, StateSetter setModalState) {
          var maskFormatter = new MaskTextInputFormatter(
              mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')});
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
                  TextField(
                    controller: phoneNumberController,
                    inputFormatters: [maskFormatter],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '+7(___) ___-__-__'),
                  ),
                  CheckboxListTile(
                    title: Text(
                        "Ознакомлен с условиями положения о защите персональных данных"),
                    value: isFamiliarized,
                    onChanged: (newValue) => setModalState(() {
                      isFamiliarized = newValue!;
                    }),
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  CheckboxListTile(
                    title: Text(
                        "Даю свое согласие на обработку персональных данных"),
                    value: isAgreed,
                    onChanged: (newValue) => setModalState(() {
                      isAgreed = newValue!;
                    }),
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Mutation(
                    options: MutationOptions(
                      document: gql(loginClient),
                      onError: (error) {
                        print("ERROR");
                        print(error);
                      },
                      onCompleted: (dynamic resultData) async {
                        print(resultData);
                        if (resultData['loginClient']['result'] == 0) {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                              'token', resultData['loginClient']['token']);
                          Navigator.pop(context);
                          _confirmSMS(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Ошибка'),
                              content: Text(
                                  resultData['loginClient']['errorMessage']),
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
                      return ElevatedButton(
                          onPressed: isAgreed && isFamiliarized
                              ? () async {
                                  PhoneNumber phoneNumber =
                                      await PhoneNumberUtil()
                                          .parse(phoneNumberController.text);
                                  print('7' + phoneNumber.nationalNumber);
                                  runMutation({
                                    'clientPhone': int.parse(
                                        '7' + phoneNumber.nationalNumber),
                                  });
                                }
                              : null,
                          child: Text("ВОЙТИ"));
                    },
                  ),
                ],
              ),
            ),
          );
        });
      },
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
        return StatefulBuilder(
          builder: (context, StateSetter setModalState) {
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
                  TextField(
                    controller: smsCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: '12345'),
                  ),
                  Mutation(
                    options: MutationOptions(
                        document: gql(checkClient),
                        onError: (error) {
                          print("ERROR");
                          print(error!.graphqlErrors[0].message);
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
                          print(resultData);
                          if (resultData != null) {
                            if (resultData['checkClient']['result'] == 0) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString(
                                  'token', resultData['checkClient']['token']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainPage()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Ошибка'),
                                  content: Text(resultData['checkClient']
                                      ['errorMessage']),
                                  actions: <Widget>[
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
                        }),
                    builder: (
                      RunMutation runMutation,
                      QueryResult? result,
                    ) {
                      return ElevatedButton(
                          child: Text("ПОДТВЕРДИТЬ"),
                          onPressed: () {
                            print("SMS NOW PLZ " + smsCodeController.text);
                            runMutation({
                              'code': smsCodeController.text,
                            });
                          });
                    },
                  ),
                ]),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogPage(
      image: AssetImage('assets/Включить оповещения@2x.png'),
      title: "Войти",
      body:
          "В личном кабинете можно будет составлять списки покупок, контролировать счет и тратить бонусы.",
      child: Row(
        children: [
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ))),
            child: Text("ВОЙТИ"),
            onPressed: () => _userLogin(context),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
              },
              child: Text("ПОЗЖЕ")),
        ],
      ),
    );
  }
}
