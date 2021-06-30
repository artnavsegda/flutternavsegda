import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'user.dart';
import 'product.dart';

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
          Image(
            image: AssetImage('assets/background.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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
              GestureDetector(
                onTap: () {
                  print("Hello");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrPage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                  width: 288,
                  height: 164,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            Color(0xff76B36D),
                            Color(0xffCCED89)
                          ])),
                  child: Stack(children: [
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Image(
                            image: AssetImage('assets/logotype-levrana.png'))),
                    Positioned(
                      left: 16,
                      bottom: 10,
                      child: Row(
                        children: [
                          Query(
                              options:
                                  QueryOptions(document: gql(getClientInfo)),
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
                              image:
                                  AssetImage('assets/ic-24/icon-24-bonus.png'))
                        ],
                      ),
                    ),
                    Positioned(
                        top: 22,
                        right: 16,
                        child: Image(image: AssetImage('assets/Union.png'))),
                    Positioned(
                        right: 16,
                        bottom: 37,
                        child:
                            Image(image: AssetImage('assets/Group 145.png'))),
                  ]),
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
                              (section) => Container(
                                margin: EdgeInsets.fromLTRB(0, 33, 0, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(section['name'],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      Wrap(
                                          children: section['products']
                                              .map(
                                                (product) => ProductCard(
                                                    product: product),
                                              )
                                              .toList()
                                              .cast<Widget>()),
                                    ]),
                              ),
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

class QrPage extends StatelessWidget {
  const QrPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Бонусная карта", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Image(
            image: AssetImage('assets/Сканировать QR код.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.1696),
                            blurRadius: 0.0,
                            offset: Offset(0.0, 2),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.250),
                            blurRadius: 15.11,
                            offset: Offset(0.0, 12.02),
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(85, 146, 80, 0.250),
                            blurRadius: 80,
                            offset: Offset(0.0, 42),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: QrImage(
                      data: "1234567890",
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  Text("Показать на кассе"),
                  Text("+7 921 939 49 40"),
                  Text(
                      "Поднесите телефон к QR сканеру чтобы начислить или списать бонусы."),
                  ElevatedButton(
                    child: Text("Добавить в Wallet"),
                    onPressed: () {},
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}
