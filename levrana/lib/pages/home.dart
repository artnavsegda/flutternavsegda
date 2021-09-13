import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:phone_number/phone_number.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'user.dart';
import 'product.dart';
import 'actions.dart';

const String getActions = r'''
query getActions {
  getActions {
    iD
    name
    picture
  }
}
''';

const String getTopBlocks = r'''
query getTopBlocks {
  getTopBlocks
  {
    name
    products {
      iD
      name
      picture
      type
    }
  }
}
''';

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrPage()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(16, 21, 16, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
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
                                options:
                                    QueryOptions(document: gql(getClientInfo)),
                                builder: (result, {fetchMore, refetch}) {
                                  //print(result.data);

                                  if (result.hasException) {
                                    return Text("0",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 40,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white));
                                    return Text(result.exception.toString());
                                  }

                                  if (result.isLoading) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  return Text(
                                      result.data!['getClientInfo']['points']
                                          .toString(),
                                      style: GoogleFonts.montserrat(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white));
                                }),
                            Image(
                                image: AssetImage(
                                    'assets/ic-24/icon-24-bonus.png'))
                          ],
                        ),
                      ),
                      Positioned(
                          top: 22,
                          right: 16,
                          child: Image(image: AssetImage('assets/Union.png'))),
                      Positioned(
                          right: 16,
                          top: 100,
                          child:
                              Image(image: AssetImage('assets/Group 145.png'))),
                    ]),
                  ),
                ),
              ),
              Query(
                  options: QueryOptions(document: gql(getActions)),
                  builder: (result, {fetchMore, refetch}) {
                    //print(result.data);

                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

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
                          itemCount: result.data!['getActions'].length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {
                                print(result.data!['getActions'][index]['iD']);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActionPage(
                                            actionID: result.data!['getActions']
                                                [index]['iD'],
                                          )),
                                );
                                refetch!();
                              },
                              child: Container(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6.0),
                                  child: Image.network(
                                      result.data!['getActions'][index]
                                          ['picture'],
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
                  options: QueryOptions(document: gql(getTopBlocks)),
                  builder: (result, {fetchMore, refetch}) {
                    //print(result.data);

                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: result.data!['getTopBlocks']
                            .map(
                              (section) => Container(
                                margin: EdgeInsets.fromLTRB(8, 33, 8, 0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(section['name'],
                                          style: GoogleFonts.montserrat(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                          )),
                                      SizedBox(height: 16),
                                      Wrap(
                                          spacing: 16,
                                          runSpacing: 16,
                                          children: section['products']
                                              .map(
                                                (product) =>
                                                    FractionallySizedBox(
                                                  widthFactor: 0.45,
                                                  child: ProductCard(
                                                      product: product,
                                                      onTap:
                                                          () => Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        ProductPage(
                                                                            id: product['iD'])),
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
                  })
            ],
          ),
        ],
      )),
    );
  }
}

class QrPage extends StatelessWidget {
  const QrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
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
            image: AssetImage('assets/QR.png'),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Query(
            options: QueryOptions(document: gql(getClientInfo)),
            builder: (result, {fetchMore, refetch}) {
              //print(result.data);

              if (result.hasException) {
                return Center(child: Text("Карта недоступна"));
                return Text(result.exception.toString());
              }

              if (result.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              String phone =
                  "+" + result.data!['getClientInfo']['phone'].toString();

              Future<PhoneNumber> futurePhone = PhoneNumberUtil().parse(phone);

              return Column(children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
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
                        data: result.data!['getClientInfo']['clientGUID'],
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          runSpacing: 8,
                          children: [
                            Text("Показать на кассе",
                                style: GoogleFonts.montserrat(
                                    fontSize: 28, fontWeight: FontWeight.w700)),
                            FutureBuilder<Object>(
                                future: futurePhone,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    var phoneNumber =
                                        snapshot.data as PhoneNumber;

                                    return Text(phoneNumber.international,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.green));
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                }),
                            Text(
                                "Поднесите телефон к QR сканеру чтобы начислить или списать бонусы."),
                          ],
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.black,
                            minimumSize: Size(double.infinity, 48),
                          ),
                          child: Text("ДОБАВИТЬ В WALLET"),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ]);
            },
          ),
        ],
      ),
    );
  }
}
