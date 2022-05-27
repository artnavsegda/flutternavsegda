import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'package:nord/sever_metropol_icons.dart';

class CreateAddress extends StatelessWidget {
  const CreateAddress({Key? key, required this.addressToCreate})
      : super(key: key);
  final GraphNewDeliveryAddress addressToCreate;

  @override
  Widget build(BuildContext context) {
    TextEditingController addressController =
        TextEditingController(text: addressToCreate.address);
    TextEditingController descriptionController =
        TextEditingController(text: addressToCreate.description);
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
        title: Text('Адрес доставки'),
      ),
      body: ListView(
        children: [
          TextField(controller: addressController),
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
          TextField(controller: descriptionController),
        ],
      ),
      bottomSheet: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Mutation(
              options: MutationOptions(
                document: gql(addDeliveryAddress),
                onError: (error) {
                  showErrorAlert(context, error!.graphqlErrors[0].message);
                },
                onCompleted: (resultData) {
                  print(resultData);
                  if (resultData != null) {
                    GraphBasisResult nordResult = GraphBasisResult.fromJson(
                        resultData['addDeliveryAddress']);
                    if (nordResult.result == 0) {
                      Navigator.pop(context);
                    }
                    if (nordResult.errorMessage?.isNotEmpty ?? false)
                      showErrorAlert(context, nordResult.errorMessage ?? '');
                  }
                },
              ),
              builder: (runMutation, result) {
                return ElevatedButton(
                  child: const Text('Сохранить адрес'),
                  onPressed: () {
                    var newAddressToCreate = GraphNewDeliveryAddress(
                      address: addressController.text,
                      longitude: addressToCreate.longitude,
                      latitude: addressToCreate.latitude,
                      description: descriptionController.text,
                    );
                    runMutation({
                      'newAddress': newAddressToCreate.toJson(),
                    });
                  },
                );
              })),
    );
  }
}
