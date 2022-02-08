import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../gql.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getTopBlocks),
      ),
      builder: (result, {fetchMore, refetch}) {
        print(result);
        if (result.isLoading || result.hasException) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GraphTopBlock> topBlocks = List<GraphTopBlock>.from(result
            .data!['getTopBlocks']
            .map((model) => GraphTopBlock.fromJson(model)));

        return ListView.builder(
            itemCount: topBlocks.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(topBlocks[index].name),
                  Column(
                      children: topBlocks[index]
                          .products
                          .map(
                            (e) => ListTile(
                              title: Text(e.name),
                              onTap: () {
                                context.goNamed('product', params: {
                                  'tab': '0',
                                  'id': '${e.iD}',
                                });
                              },
                            ),
                          )
                          .toList()
                          .cast<Widget>()),
                ],
              );
            });
      },
    );
  }
}
