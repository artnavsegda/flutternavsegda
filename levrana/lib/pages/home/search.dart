import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../gql.dart';
import '../../components/product_card.dart';
import '../product/product.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key? key,
    required this.searchString,
  }) : super(key: key);

  final String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск “$searchString”'),
      ),
      body: Query(
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

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<GraphProduct> items = List<GraphProduct>.from(result
              .data!['findProducts']
              .map((model) => GraphProduct.fromJson(model)));

          return StaggeredGridView.countBuilder(
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            crossAxisCount: 2,
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductCard(
                  product: items[index],
                  onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductPage(id: items[index].iD)),
                      )),
            ),
            staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          );
        },
      ),
    );
  }
}
