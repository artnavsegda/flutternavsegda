import 'package:flutter/material.dart';
import 'package:nord/gql.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CreateAddress extends StatelessWidget {
  const CreateAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Адрес доставки')),
      body: Column(),
    );
  }
}
