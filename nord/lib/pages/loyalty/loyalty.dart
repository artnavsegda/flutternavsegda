import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:expandable/expandable.dart';
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

              PageController _controller =
                  PageController(viewportFraction: 0.9);

              List<GraphLoyaltyTier> loyaltyTiers = List<GraphLoyaltyTier>.from(
                  result.data!['getLoyaltyTiers']
                      .map((model) => GraphLoyaltyTier.fromJson(model)));

              return ListView(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 8,
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: loyaltyTiers.length,
                      itemBuilder: (context, index) {
                        GraphLoyaltyTier loyaltyTier = loyaltyTiers[index];
                        return Container(
                          decoration: loyaltyTier.active
                              ? BoxDecoration(
                                  border: Border.all(),
                                )
                              : BoxDecoration(
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
                  Center(
                    child: SmoothPageIndicator(
                        axisDirection: Axis.horizontal,
                        controller: _controller,
                        count: 4,
                        effect: const ExpandingDotsEffect(
                            spacing: 4.0,
                            //radius: 4.0,
                            dotWidth: 5.0,
                            dotHeight: 5.0,
                            expansionFactor: 6,
                            activeDotColor: Color(0xFFB0063A)),
                        onDotClicked: (index) {}),
                  ),
                  ExpandableNotifier(
                    initialExpanded: true,
                    child: ExpandablePanel(
                      header: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'О бонусной программе',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      theme: ExpandableThemeData(
                        iconPadding: EdgeInsets.all(16.0),
                        iconColor: Colors.red[900],
                        expandIcon: SeverMetropol.Icon_Expand_More,
                        collapseIcon: SeverMetropol.Icon_Expand_More,
                      ),
                      collapsed: const SizedBox.shrink(),
                      expanded: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• "),
                                Flexible(
                                  child: Text(
                                      'Оплачивайте до 20% от покупок бонусами. 1 бонус = 1 рублю!'),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• "),
                                Flexible(
                                  child: Text(
                                      'Каждые 3 месяца Ваш уровень обновляется. Уровень повышается на 3 месяца, если сумма покупок равна или выше достигнутого уровня.'),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("• "),
                                Flexible(
                                  child: Text(
                                      'Бонусы сгорают постепенно. Если с последней покупки прошло 30 дней, то 50% бонусных накоплений сгорают. Через ещё 60 дней сгорают оставшиеся бонусы (90 дней с последней покупки).'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                        onPressed: () {},
                        label: Icon(SeverMetropol.Icon_East),
                        icon: Text('Подробнее о бонусной программе')),
                  )
                ],
              );
            }));
  }
}
