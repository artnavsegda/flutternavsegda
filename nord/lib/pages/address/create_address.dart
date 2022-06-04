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
    TextEditingController entranceController = TextEditingController();
    TextEditingController intercomController = TextEditingController();
    TextEditingController floorController = TextEditingController();
    TextEditingController apartmentController = TextEditingController();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: addressController,
                enabled: false,
                style: TextStyle(color: Color(0xFF9CA4AC)),
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    SeverMetropol.Icon_Lock,
                    size: 24.0,
                    color: Colors.red[900],
                  ),
                  labelText: "Адрес",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: entranceController,
                    decoration: InputDecoration(
                      labelText: "Подъезд",
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: intercomController,
                    decoration: InputDecoration(
                      labelText: "Домофон",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: floorController,
                    decoration: InputDecoration(
                      labelText: "Этаж",
                    ),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: apartmentController,
                    decoration: InputDecoration(
                      labelText: "Квартира",
                    ),
                  ),
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Название адреса",
                ),
              ),
            ),
          ],
        ),
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
                    } else
                      showErrorAlert(
                          context, nordResult.errorMessage ?? 'error');
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
