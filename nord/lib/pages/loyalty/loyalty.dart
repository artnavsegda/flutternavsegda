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

              List<GraphLoyaltyTier> loyaltyTiers = List<GraphLoyaltyTier>.from(
                  result.data!['getLoyaltyTiers']
                      .map((model) => GraphLoyaltyTier.fromJson(model)));

              int activeTier =
                  loyaltyTiers.indexWhere((element) => element.active);

              PageController _controller = PageController(
                viewportFraction: 0.93,
                initialPage: activeTier,
              );

              return ListView(
                children: [
                  Container(
                    height: 280,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        PageView.builder(
                          controller: _controller,
                          itemCount: loyaltyTiers.length,
                          itemBuilder: (context, index) {
                            GraphLoyaltyTier loyaltyTier = loyaltyTiers[index];
                            return Container(
                              margin: const EdgeInsets.only(
                                left: 4.0,
                                right: 4.0,
                                top: 16,
                                bottom: 32,
                              ),
                              decoration: loyaltyTier.active
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x1F000000),
                                          blurRadius: 20,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                      border:
                                          Border.all(color: Color(0xffB0063A)),
                                    )
                                  : BoxDecoration(
                                      boxShadow: [
                                          BoxShadow(
                                            color: Color(0x1F000000),
                                            blurRadius: 20,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      borderRadius: BorderRadius.circular(4),
                                      gradient: const LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xffCD0643),
                                            Color(0xffB0063A)
                                          ])),
                              child: ListTileTheme(
                                textColor:
                                    loyaltyTier.active ? null : Colors.white,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                          loyaltyTier.active
                                              ? 'Ваш уровень'
                                              : 'Уровень',
                                          style: TextStyle(fontSize: 10)),
                                      subtitle: Text(loyaltyTier.name,
                                          style: TextStyle(fontSize: 16)),
                                      leading: Image.network(
                                        loyaltyTier.picture ?? '',
                                        width: 42,
                                        height: 42,
                                      ),
                                    ),
                                    ListTile(
                                      subtitle: Text('Начисление за покупки'),
                                      title: Text(
                                          loyaltyTier.pointOrder.toString() +
                                              '%'),
                                      leading: Image.asset(
                                          'assets/Illustration-Colored-Bonuses.png'),
                                    ),
                                    loyaltyTier.condition == 0
                                        ? ListTile(
                                            subtitle: Text(
                                                'Этот уровень для каждого клиента'),
                                            title: Text('С вами навсегда!'),
                                            leading: Image.asset(
                                                'assets/Illustration-Colored-Infinte.png'),
                                          )
                                        : ListTile(
                                            onTap: () {},
                                            subtitle:
                                                Text('Начисление за покупки'),
                                            title: Text(
                                                'От ${loyaltyTier.condition.toString()} ₽'),
                                            leading: Image.asset(
                                                'assets/Illustration-Colored-New-Level.png'),
                                            trailing: loyaltyTier
                                                    .message!.isNotEmpty
                                                ? Tooltip(
                                                    preferBelow: false,
                                                    triggerMode:
                                                        TooltipTriggerMode.tap,
                                                    message:
                                                        loyaltyTier.message,
                                                    child: Icon(
                                                      SeverMetropol.Icon_Info,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 20,
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
                        )
                      ],
                    ),
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
