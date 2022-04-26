import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/product_card.dart';
import '../product/product.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? searchString;
  TextEditingController textController = TextEditingController();

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
          title: TextField(
            controller: textController,
            style: const TextStyle(fontFamily: 'Forum', fontSize: 20.0),
            decoration: const InputDecoration(
                hintText: 'Название товара',
                isDense: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                filled: false),
            autofocus: true,
            onChanged: (value) {
              if (value.length > 1) {
                setState(() {
                  searchString = value;
                });
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                SeverMetropol.Icon_Clear,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                textController.clear();
                setState(() {
                  searchString = null;
                });
              },
            ),
          ],
        ),
        body: searchString == null
            ? const Center(child: Text('Что ищем ?'))
            : Query(
                options: QueryOptions(
                  document: gql(findProducts),
                  variables: {
                    'searchBox': searchString,
                  },
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading && result.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<GraphProduct> items = List<GraphProduct>.from(result
                      .data!['findProducts']
                      .map((model) => GraphProduct.fromJson(model)));

                  if (items.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Image.asset(
                            'assets/Illustration-Not-Found.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Уфф...\nНичего не нашлось",
                                  style: TextStyle(
                                    fontFamily: 'Forum',
                                    fontSize: 24.0,
                                  )),
                              SizedBox(height: 8),
                              Text(
                                  "Попробуйте изменить запрос или поискать что-нибудь вкусное в новинках",
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return SingleChildScrollView(
                    child: Center(
                      widthFactor: 1.23,
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          ...items
                              .map(
                                (element) => FractionallySizedBox(
                                  widthFactor: 0.43,
                                  child: ProductCard(
                                      onReload: () => refetch!(),
                                      product: element,
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductPage(id: element.iD)),
                                        );
                                        refetch!();
                                      }),
                                ),
                              )
                              .toList()
                              .cast<Widget>(),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
