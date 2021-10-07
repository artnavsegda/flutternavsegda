import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import '../../main.dart';
import '../../gql.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          children: [
            Text("Пароль",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
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
            Mutation(
                options: MutationOptions(
                  document: gql(forgotPassword),
                  onCompleted: (dynamic resultData) async {
                    print(resultData);
                    Navigator.pop(context);
                    _confirmSMS(context);
                  },
                ),
                builder: (
                  RunMutation runMutation,
                  QueryResult? result,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              48), // double.infinity is the width and 30 is the height
                        ),
                        onPressed: () {
                          runMutation({});
                        },
                        child: Text("ЗАБЫЛ ПАРОЛЬ",
                            style: TextStyle(fontSize: 16))),
                  );
                })
          ],
        ),
      ),
    );
  }
}
