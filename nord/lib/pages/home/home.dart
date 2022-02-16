import 'package:flutter/material.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../gql.dart';
import '../../components/product_card.dart';
import 'action_card.dart';
import 'discount_card.dart';
import '../map/map.dart';
import '../../components/components.dart';
import '../../components/gradient_button.dart';
import '../../login_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  _buildActionsBlock(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getActions),
        //fetchPolicy: FetchPolicy.cacheFirst,
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading || result.hasException) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(6.0)),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Shimmer.fromColors(
                baseColor: const Color(0xFFECECEC),
                highlightColor: Colors.white,
                child: Container(
                    decoration: BoxDecoration(
                  color: const Color(0xFFECECEC),
                  borderRadius: BorderRadius.circular(6.0),
                )),
              ),
            ),
          );
        }

        List<GraphAction> actions = List<GraphAction>.from(result
            .data!['getActions']
            .map((model) => GraphAction.fromJson(model)));

        return SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 12,
              ),
/*               ActionCard(
                  actionName: 'Взрывная весна!\nОткрой новые вкусы сладко...',
                  actionImage: 'assets/placeholder/action/Illustration.png',
                  actionDate: '15 октября–27 ноября'),
              ActionCard(
                  actionName: 'Шокодень',
                  actionImage: 'assets/placeholder/cake.png',
                  actionDate: 'Только до 31 октября'), */
              ...actions.map(
                (action) => ActionCard(
                    actionID: action.iD,
                    actionName: action.name,
                    actionImage: action.picture,
                    actionDate: 'Только до 31 октября'),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildLoadingShimmerPlaceholder(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 33, 8, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            width: 100,
            child: Shimmer.fromColors(
              baseColor: const Color(0xFFECECEC),
              highlightColor: Colors.white,
              child: Container(
                  decoration: const BoxDecoration(
                color: Color(0xFFECECEC),
              )),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              FractionallySizedBox(
                widthFactor: 0.45,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xFFECECEC),
                    highlightColor: Colors.white,
                    child: Container(
                        decoration: BoxDecoration(
                      color: const Color(0xFFECECEC),
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.45,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Shimmer.fromColors(
                    baseColor: const Color(0xFFECECEC),
                    highlightColor: Colors.white,
                    child: Container(
                        decoration: BoxDecoration(
                      color: const Color(0xFFECECEC),
                      borderRadius: BorderRadius.circular(6.0),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBlocks(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getTopBlocks),
          //fetchPolicy: FetchPolicy.cacheFirst,
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading || result.hasException) {
            return _buildLoadingShimmerPlaceholder(context);
          }

          List<GraphTopBlock> topBlocks = List<GraphTopBlock>.from(result
              .data!['getTopBlocks']
              .map((model) => GraphTopBlock.fromJson(model)));

          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: topBlocks
                  .map(
                    (section) => Container(
                      //margin: const EdgeInsets.fromLTRB(8, 33, 8, 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(section.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 240,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(
                                    width: 12,
                                  ),
                                  ...section.products.map((product) =>
                                      ProductCard(
                                          productID: product.iD,
                                          productImage: product.picture ?? '',
                                          productName: product.name,
                                          productPrice: '420')),
                                  ProductCard(
                                    productID: 1,
                                    productImage:
                                        'https://demo.cyberiasoft.com/SeverMetropolService/api/tools/picture/52.png?IsPreview=true&refresh=637797843623200000',
                                    productName: 'Анна Павлова',
                                    productPrice: '315',
                                  ),
                                  ProductCard(
                                    productID: 1,
                                    productImage:
                                        'https://demo.cyberiasoft.com/SeverMetropolService/api/tools/picture/48.png?IsPreview=true&refresh=637797839489000000',
                                    productName: 'Торт «Сезонный» с ягодами',
                                    productPrice: '420',
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  )
                  .toList()
                  .cast<Widget>());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const AddressTile(),
          Provider.of<LoginState>(context, listen: false).loggedIn
              ? CardLoggedIn()
              : CardNotLoggedIn(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child:
                Text("Акции", style: Theme.of(context).textTheme.headlineSmall),
          ),
          _buildActionsBlock(context),
          _buildTopBlocks(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text("Кондитерские и кафе",
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000), //Color.fromRGBO(0, 0, 0, 0.12),
                  blurRadius: 20.0,
                  offset: Offset(0.0, 4.0),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                image: const DecorationImage(
                  image: AssetImage("assets/Map.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: AspectRatio(
                aspectRatio: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: GradientButton.icon(
                      style: ElevatedButton.styleFrom(
                        //elevation: 0.0,
                        visualDensity: VisualDensity.compact,
                      ),
                      label: Icon(SeverMetropol.Icon_East),
                      icon: const Text('Показать заведения на карте'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MapPage()));
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
