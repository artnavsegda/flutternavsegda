import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../gql.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Query(
              options: QueryOptions(
                document: gql(getActions),
              ),
              builder: (result, {fetchMore, refetch}) {
                print(result);
                if (result.isLoading || result.hasException) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<GraphAction> actions = List<GraphAction>.from(result
                    .data!['getActions']
                    .map((model) => GraphAction.fromJson(model)));

                return Column(
                    children: actions
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
                        .cast<Widget>());
              },
            ),
            Query(
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

                return Column(
                    children: topBlocks
                        .map((block) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(block.name),
                              Column(
                                  children: block.products
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
                        })
                        .toList()
                        .cast<Widget>());
              },
            ),
          ],
        ),
      ),
    );
  }
}
