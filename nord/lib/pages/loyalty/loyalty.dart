import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/pages/error/error.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({Key? key}) : super(key: key);

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
          title: const Text('Ваш уровень'),
        ),
        body: Query(
            options: QueryOptions(
              document: gql(getLoyaltyTiers),
            ),
            builder: (result, {refetch, fetchMore}) {
              if (result.hasException) {
                return ErrorPage(reload: () {
                  refetch!();
                });
              }

              if (result.isLoading && result.data == null) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await refetch!();
                    //await Future.delayed(Duration(seconds: 5));
                  },
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              List<GraphLoyaltyTier> loyaltyTiers = List<GraphLoyaltyTier>.from(
                  result.data!['getLoyaltyTiers']
                      .map((model) => GraphLoyaltyTier.fromJson(model)));

              return ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 8,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.9),
                      itemCount: loyaltyTiers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color(0xffCD0643),
                                    Color(0xffB0063A)
                                  ])),
                        );
                      },
                    ),
                  ),
                ],
              );
            }));
  }
}
