import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:nord/gql.dart';
import 'package:nord/utils.dart';

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
    return Container(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          runSpacing: 8.0,
          children: [
            const Text('Промокод'),
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                labelText: "Введите промокод",
              ),
            ),
            Mutation(
                options: MutationOptions(
                  document: gql(promocodeActivation),
                  onError: (error) {
                    showErrorAlert(context, error!.graphqlErrors[0].message);
                  },
                  onCompleted: (resultData) {
                    print(resultData);
                    if (resultData != null) {
                      GraphPromocodeResult nordPromocodeResult =
                          GraphPromocodeResult.fromJson(
                              resultData['promocodeActivation']);
                      if (nordPromocodeResult.result == 0) {
                        Navigator.pop(context);
                      }
                      showErrorAlert(
                          context, nordPromocodeResult.errorMessage ?? '');
                    }
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
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
      ),
    );
  }
}
