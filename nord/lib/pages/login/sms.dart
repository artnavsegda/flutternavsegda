import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:nord/login_state.dart';
import 'package:nord/utils.dart';
import 'package:nord/gql.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({Key? key, this.phone}) : super(key: key);

  final String? phone;

  @override
  State<SmsPage> createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
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
    startTickingClock();
    super.initState();
  }

  void startTickingClock() {
    _timeDilationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text('Введите\nкод подтверждения',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 9),
            Text('Код подтверждения был отправлен на номер:\n${widget.phone}'),
            const SizedBox(height: 24),
            TextField(
              controller: smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: "Код подтверждения",
                  suffixIcon: IconButton(
                    onPressed: () {
                      smsCodeController.clear();
                    },
                    icon: Icon(
                      SeverMetropol.Icon_Clear,
                      size: 24.0,
                    ),
                  )),
            ),
            const SizedBox(height: 16),
            Mutation(
                options: MutationOptions(
                  document: gql(checkClient),
                  onError: (error) {
                    showErrorAlert(context, '$error');
                  },
                  onCompleted: (dynamic resultData) {
                    GraphClientResult nordClientResult =
                        GraphClientResult.fromJson(resultData['checkClient']);
                    if (nordClientResult.result == 0) {
                      context.read<LoginState>().token =
                          nordClientResult.token ?? '';
                      context.read<LoginState>().loggedIn = true;
                      context.go('/main');
                    } else {
                      showErrorAlert(
                          context, nordClientResult.errorMessage ?? '');
                    }
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                      onPressed: () {
                        runMutation({
                          'code': smsCodeController.text,
                          'step': 'SMS_CONFIRMED_PHONE',
                        });
                      },
                      child: const Text('Подтвердить'));
                }),
            const SizedBox(height: 8),
            Mutation(
                options: MutationOptions(
                    document: gql(newCodeSMS),
                    onError: (error) {
                      showErrorAlert(context, error!.graphqlErrors[0].message);
                    },
                    onCompleted: (dynamic resultData) {
                      if (resultData != null) {
                        GraphBasisResult nordBasisResult =
                            GraphBasisResult.fromJson(resultData['newCodeSMS']);

                        if (nordBasisResult.result == 0) {
                          setState(() {
                            smsTimeout = 30;
                          });
                          startTickingClock();
                        } else {
                          showErrorAlert(
                              context, nordBasisResult.errorMessage ?? '');
                        }
                      }
                    }),
                builder: (runMutation, result) {
                  return TextButton(
                      onPressed: smsTimeout == 0 ? () => runMutation({}) : null,
                      child: smsTimeout == 0
                          ? Text('Запросить новый код')
                          : Text(
                              'Запросить новый код через 00:${smsTimeout.toString().padLeft(2, '0')}'));
                }),
          ],
        ),
      ),
    );
  }
}
