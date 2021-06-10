import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAgreed = false;
  bool isFamiliarized = false;
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
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
            child: Text("РАЗРЕШИТЬ"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: const Radius.circular(16.0)),
                ),
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, StateSetter setModalState) {
                    var maskFormatter = new MaskTextInputFormatter(
                        mask: '+7 (###) ###-##-##',
                        filter: {"#": RegExp(r'[0-9]')});
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
                              controller: textController,
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
                                document: gql(
                                    loginClient), // this is the mutation string you just created
                                // or do something with the result.data on completion
                                onCompleted: (dynamic resultData) async {
                                  print(resultData);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('token',
                                      resultData['authenticate']['token']);
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
                                                    .parse(textController.text);
                                            print('7' +
                                                phoneNumber.nationalNumber);
                                            runMutation({
                                              'clientPhone': int.parse('7' +
                                                  phoneNumber.nationalNumber),
                                            });
                                          }
                                        : null,
                                    child: Text("ВОЙТИ"));
                              },
                            ),
/*                             ElevatedButton(
                                onPressed: isAgreed && isFamiliarized
                                    ? () async {
                                        PhoneNumber phoneNumber =
                                            await PhoneNumberUtil()
                                                .parse(textController.text);
                                        print(phoneNumber.nationalNumber);
                                      }
                                    : null,
                                child: Text("ВОЙТИ")), */
                          ],
                        ),
                      ),
                    );
                  });
                },
              );
            },
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
