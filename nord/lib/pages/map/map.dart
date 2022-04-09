import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/shop_tile.dart';
import 'package:nord/pages/error/error.dart';
import '../shop/shop.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getShops),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.hasException) {
          return ErrorPage(
            reload: () {
              refetch!();
            },
            errorText: result.exception?.graphqlErrors[0].message ?? '',
          );
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GraphShop> shops = List<GraphShop>.from(
            result.data!['getShops'].map((model) => GraphShop.fromJson(model)));

        return FutureBuilder<Position>(
          future: Geolocator.getCurrentPosition(),
          builder: (context, snapshot) {
            LatLng myLocation = LatLng(59.9311, 30.3609);
            if (snapshot.hasData) {
              myLocation =
                  LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text('Кондитерские и кафе'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      SeverMetropol.Icon_West,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: myLocation,
                      zoom: 10,
                    ),
                    markers: shops.map(
                      (shop) {
                        return Marker(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShopPage(shop: shop)));
                            },
                            markerId: MarkerId(shop.name),
                            position: LatLng(
                                shop.latitude ?? 0, shop.longitude ?? 0));
                      },
                    ).toSet(),
                  ),
                  DraggableScrollableSheet(
                    minChildSize: 0.15,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: ListView(
                          controller: scrollController,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(top: 8.0),
                              child: SizedBox(
                                width: 32,
                                height: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[900],
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: const TextField(
                                decoration: InputDecoration(
                                    hintText: 'Поиск по названию или адресу',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(2.0),
                                      ),
                                    ),
                                    filled: true),
                              ),
                            ),
                            ...shops.map((shop) => ShopTile(shop: shop)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
