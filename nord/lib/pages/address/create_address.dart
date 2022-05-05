import 'package:flutter/material.dart';
import 'package:nord/gql.dart';
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
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Сохранить адрес'),
        ),
      ),
    );
  }
}
