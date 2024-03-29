import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../gql.dart';
import '../../components/productCard.dart';

import '../product/product.dart';
import 'action.dart';
import 'qr.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _controller = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    Future Function()? refetchClientInfo;
    Future Function()? refetchActions;
    Future Function()? refetchTopBlocks;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await refetchClientInfo!();
          await refetchActions!();
          await refetchTopBlocks!();
          await Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Image(
              image: AssetImage('assets/background.png'),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                /*               Container(
                  margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                  child: TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: new OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(12.0),
                          ),
                        ),
                        filled: true),
                  ),
                ), */
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QrPage()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: <Color>[
                              Color(0xff76B36D),
                              Color(0xffCCED89)
                            ])),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(children: [
                        Positioned(
                            top: 20,
                            left: 20,
                            child: Image(
                                image:
                                    AssetImage('assets/logotype-levrana.png'))),
                        Positioned(
                          left: 16,
                          bottom: 10,
                          child: Row(
                            children: [
                              Query(
                                  options: QueryOptions(
                                    document: gql(getClientInfo),
                                    fetchPolicy: FetchPolicy.cacheFirst,
                                  ),
                                  builder: (result, {fetchMore, refetch}) {
                                    //print(result.data);
                                    refetchClientInfo = () async {
                                      print("refetch client info");
                                      await refetch!();
                                    };

                                    if (result.hasException) {
                                      return Text("0",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 40.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white));
                                      return Text(result.exception.toString());
                                    }

                                    if (result.isLoading) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    GraphClientFullInfo userInfo =
                                        GraphClientFullInfo.fromJson(
                                            result.data!['getClientInfo']);

                                    return Text(userInfo.points.toString(),
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 40.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white));
                                  }),
                              Image(
                                  fit: BoxFit.contain,
                                  width: 48,
                                  height: 48,
                                  image: AssetImage(
                                      'assets/ic-24/icon-24-bonus.png'))
                            ],
                          ),
                        ),
                        Positioned(
                            top: 22,
                            right: 16,
                            child:
                                Image(image: AssetImage('assets/Union.png'))),
                        Positioned(
                            right: 16,
                            top: 100,
                            child: Image(
                                image: AssetImage('assets/Group 145.png'))),
                      ]),
                    ),
                  ),
                ),
                Query(
                    options: QueryOptions(
                        document: gql(getActions),
                        fetchPolicy: FetchPolicy.cacheFirst),
                    builder: (result, {fetchMore, refetch}) {
                      //print(result.data);
                      refetchActions = () async {
                        print("refetch actions");
                        await refetch!();
                      };

                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<GraphAction> actions = List<GraphAction>.from(result
                          .data!['getActions']
                          .map((model) => GraphAction.fromJson(model)));

                      /*                     return CarouselSlider.builder(
                        options: CarouselOptions(
                            height: 200.0,
                            enableInfiniteScroll: false,
                            disableCenter: true,
                            viewportFraction:
                                292 / MediaQuery.of(context).size.width),
                        itemCount: result.data!['getActions'].length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            Container(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 278,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Image.network(
                                  result.data!['getActions'][itemIndex]
                                      ['picture'],
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ); */

                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 21, 0, 0),
                        //height: 160,
                        child: AspectRatio(
                          aspectRatio: 16 / 8,
                          child: PageView.builder(
                            controller: _controller,
                            itemCount: actions.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ActionPage(
                                              actionID: actions[index].iD,
                                            )),
                                  );
                                  refetch!();
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: FadeInImage.memoryNetwork(
                                        imageErrorBuilder:
                                            (context, exception, stackTrace) =>
                                                Icon(Icons.no_photography),
                                        placeholder: kTransparentImage,
                                        image: actions[index].picture ?? "",
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                Query(
                    options: QueryOptions(
                        document: gql(getTopBlocks),
                        fetchPolicy: FetchPolicy.cacheFirst),
                    builder: (result, {fetchMore, refetch}) {
                      print(result.data);
                      refetchTopBlocks = () async {
                        print("refetch top blocks");
                        await refetch!();
                      };

                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<GraphTopBlock> topBlocks = List<GraphTopBlock>.from(
                          result.data!['getTopBlocks']
                              .map((model) => GraphTopBlock.fromJson(model)));

                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: topBlocks
                              .map(
                                (section) => Container(
                                  margin: EdgeInsets.fromLTRB(8, 33, 8, 0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(section.name,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        SizedBox(height: 16),
                                        Wrap(
                                            spacing: 16,
                                            runSpacing: 16,
                                            children: section.products
                                                .map(
                                                  (product) =>
                                                      FractionallySizedBox(
                                                    widthFactor: 0.45,
                                                    child: ProductCard(
                                                        product: product,
                                                        onTap:
                                                            () =>
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          ProductPage(
                                                                              id: product.iD)),
                                                                )),
                                                  ),
                                                )
                                                .toList()
                                                .cast<Widget>()),
                                      ]),
                                ),
                              )
                              .toList()
                              .cast<Widget>());
                    }),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ],
        )),
      ),
    );
  }
}
