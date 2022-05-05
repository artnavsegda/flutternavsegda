import 'package:flutter/material.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateAddress extends StatelessWidget {
  const CreateAddress({Key? key, required this.addressToCreate})
      : super(key: key);
  final GraphDeliveryAddress addressToCreate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Адрес доставки')),
      body: ListView(
        children: [
          TextField(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: TextField()),
              Expanded(child: TextField()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: TextField()),
              Expanded(child: TextField()),
            ],
          ),
          TextField(),
        ],
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Mutation(
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
                      if (nordPromocodeResult.productID != null) {}
                    }
                    if (nordPromocodeResult.errorMessage?.isNotEmpty ?? false)
                      showErrorAlert(
                          context, nordPromocodeResult.errorMessage ?? '');
                  }
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  child: const Text('Сохранить адрес'),
                  onPressed: () {
                    runMutation({
                      'promoCode': textController.text,
                    });
                  },
                );
              })),
    );
  }
}
