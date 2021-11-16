import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../gql.dart';
import '../main.dart';

class ConfirmSMSPage extends StatefulWidget {
  const ConfirmSMSPage({
    Key? key,
  }) : super(key: key);

  @override
  _ConfirmSMSPageState createState() => _ConfirmSMSPageState();
}

class _ConfirmSMSPageState extends State<ConfirmSMSPage> {
  int smsTimeout = 30;
  Timer? _timeDilationTimer;

  final TextEditingController smsCodeController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    smsCodeController.dispose();
    _timeDilationTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    repeatSMS();
    super.initState();
  }

  void repeatSMS() {
    _timeDilationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
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
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 28,
                fontWeight: FontWeight.bold,
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
          Consumer<AppModel>(builder: (context, model, child) {
            return Mutation(
              options: MutationOptions(
                  document: gql(checkClient),
                  onError: (error) {
                    //print("ERROR");
                    //print(error!.graphqlErrors[0].message);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Ошибка'),
                        content: Text(error!.graphqlErrors[0].message),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  onCompleted: (dynamic resultData) async {
                    //print(resultData);
                    if (resultData != null) {
                      if (resultData['checkClient']['result'] == 0) {
                        await model
                            .setToken(resultData['checkClient']['token']);
                        Navigator.pop(context);
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
            );
          }),
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
                    style: TextStyle(fontSize: 16))),
          )
        ]),
      ),
    );
  }
}
