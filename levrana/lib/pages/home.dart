import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return SafeArea(
      child: SingleChildScrollView(
          child: Stack(
        children: [
          Image(image: AssetImage('assets/background.png')),
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                child: TextField(
                  decoration: InputDecoration(
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
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                width: 288,
                height: 164,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[Color(0xff76B36D), Color(0xffCCED89)])),
                child: ListTile(
                  title:
                      Image(image: AssetImage('assets/logotype-levrana.png')),
                  subtitle: Row(children: [
                    Query(
                        options: QueryOptions(document: gql(getClientInfo)),
                        builder: (result, {fetchMore, refetch}) {
                          print(result.data);
                          return Text(
                              result.data!['getClientInfo']['points']
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white));
                        }),
                    Image(
                        image: AssetImage('assets/ic-24/icon-24-bonus@2x.png'))
                  ]),
                  trailing: Column(
                    children: [
                      Image(image: AssetImage('assets/Union.png')),
                      Image(image: AssetImage('assets/Group 145.png')),
                    ],
                  ),
                ),
              ),
              Query(
                  options: QueryOptions(document: gql(getActions)),
                  builder: (result, {fetchMore, refetch}) {
                    //print(result.data);
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 21, 0, 0),
                      height: 160,
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: result.data!['getActions'].length,
                        itemBuilder: (context, index) {
                          //return Text(result.data!['getActions'][index]['name']);
                          return Container(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Image.network(
                                  result.data!['getActions'][index]['picture']),
                            ),
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
                                                  width: 200.0,
                                                  height: 200.0,
                                                  child: GridTile(
                                                    child: Image.network(
                                                        product['picture']),
                                                    footer: GridTileBar(
                                                        title: Text(
                                                            product['name'])),
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
        ],
      )),
    );
  }
}
