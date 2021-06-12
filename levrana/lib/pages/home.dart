import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'user.dart';

const String getActions = """
query getActions {
  getActions {
    iD
    name
    picture
  }
}
""";

const String getTopBlocks = """
query getTopBlocks {
  getTopBlocks
  {
    name
    products {
      iD
      name
      picture
    }
  }
}
""";

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _controller = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Query(
              options: QueryOptions(document: gql(getClientInfo)),
              builder: (result, {fetchMore, refetch}) {
                print(result.data);
                return Text(result.data!['getClientInfo']['points'].toString());
              }),
          Query(
              options: QueryOptions(document: gql(getActions)),
              builder: (result, {fetchMore, refetch}) {
                //print(result.data);
                return Container(
                  height: 160,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: result.data!['getActions'].length,
                    itemBuilder: (context, index) {
                      //return Text(result.data!['getActions'][index]['name']);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.network(
                            result.data!['getActions'][index]['picture']),
                      );
                    },
                  ),
                );
              }),
          Query(
              options: QueryOptions(document: gql(getTopBlocks)),
              builder: (result, {fetchMore, refetch}) {
                //print(result.data);
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.data!['getTopBlocks']
                        .map(
                          (section) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(section['name'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    )),
                                Wrap(
                                    children: section['products']
                                        .map((product) => SizedBox(
                                              width: 150.0,
                                              height: 150.0,
                                              child: GridTile(
                                                child: Image.network(
                                                    product['picture']),
                                                footer: GridTileBar(
                                                    title:
                                                        Text(product['name'])),
                                              ),
                                            ))
                                        .toList()
                                        .cast<Widget>()),
                                Text("Something")
                              ]),
                        )
                        .toList()
                        .cast<Widget>());
              })
        ],
      ),
    );
  }
}
