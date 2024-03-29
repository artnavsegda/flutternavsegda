import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../gql.dart';
import 'configurator.dart';
import 'productsList.dart';

class CatalogPage extends StatelessWidget {
  CatalogPage(
      {Key? key,
      required this.refetch,
      required this.catalog,
      required this.title,
      this.id = 0,
      this.totalCount = 0})
      : super(key: key);

  final List<GraphCatalog>? catalog;
  final String title;
  final int id;
  final int? totalCount;
  final refetch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          if (id != 0)
            ListTile(
              title: Text(
                "Вся продукция раздела",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              trailing: Text(
                totalCount.toString(),
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              onTap: () {
                //print(id);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductsListPage(catalogId: id, title: title)));
              },
            )
          else
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Configurator(),
                  ),
                );
              },
              child: SizedBox(
                height: 92,
                child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color.fromRGBO(255, 162, 76, 0.22),
                            Color.fromRGBO(255, 162, 76, 0)
                          ]),
                      color: Color(0xffFFF2C4),
                    ),
                    child: Row(children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("Подобрать косметику в конфигураторе"),
                      )),
                      Image.asset("assets/Bottles.png")
                    ])),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await refetch!();
                await Future.delayed(Duration(seconds: 1));
              },
              child: ListView.separated(
                itemCount: catalog!.length,
                itemBuilder: (context, index) {
                  final section = catalog![index];
                  return ListTile(
                    dense: true,
                    title: Text(
                      section.name,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    trailing: (section.childs == null)
                        ? Text(section.totalCount.toString(),
                            style: TextStyle(fontSize: 16.0))
                        : Icon(Icons.navigate_next),
                    onTap: () {
                      if (section.childs != null)
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CatalogPage(
                                    refetch: refetch,
                                    catalog: section.childs,
                                    title: section.name,
                                    id: section.iD,
                                    totalCount: section.totalCount)));
                      else {
                        //print(section['iD'].toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsListPage(
                                    catalogId: section.iD,
                                    title: section.name)));
                      }
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CatalogNavigator extends StatefulWidget {
  const CatalogNavigator({
    Key? key,
  }) : super(key: key);

  @override
  _CatalogNavigatorState createState() => _CatalogNavigatorState();
}

class _CatalogNavigatorState extends State<CatalogNavigator>
    with AutomaticKeepAliveClientMixin<CatalogNavigator> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
          builder: (BuildContext context) => Query(
                options: QueryOptions(
                  document: gql(
                      getCatalog), // this is the query string you just created
                ),
                builder: (result, {fetchMore, refetch}) {
                  if (result.hasException) {
                    return Center(child: Text("Каталог недоступен"));
                    return Center(child: Text(result.exception.toString()));
                  }

                  if (result.isLoading && result.data == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<GraphCatalog> catalog = List<GraphCatalog>.from(result
                      .data!['getCatalog']
                      .map((model) => GraphCatalog.fromJson(model)));

                  return CatalogPage(
                      catalog: catalog, title: "Каталог", refetch: refetch);
                },
              ),
          settings: settings),
    );
  }
}
