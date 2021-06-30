import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getCart = r'''
query getCart {
  getCart {
    productID
    productName
  }
}
''';

class ShoppingPage extends StatelessWidget {
  const ShoppingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(labelColor: Colors.black, tabs: [
          Tab(text: "Корзина"),
          Tab(text: "Отложенные"),
        ]),
        body: TabBarView(
          children: [
            Query(
                options: QueryOptions(document: gql(getCart)),
                builder: (result, {refetch, fetchMore}) {
                  print(result);
                  return ListView.builder(
                      itemCount: result.data!['getCart'].length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                                result.data!['getCart'][index]['productName']));
                      });

                  return Center(
                      child: Image(
                    image: AssetImage('assets/Корзина пуста.png'),
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ));
                }),
            Text("Hello")
          ],
        ),
      ),
    );
  }
}
