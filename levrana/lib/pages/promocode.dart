import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../gql.dart';

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
            Text('Промокод',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
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
                    //print(resultData);
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
      ),
    );
  }
}
