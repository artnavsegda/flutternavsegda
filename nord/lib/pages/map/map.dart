import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/shop_tile.dart';
import 'package:nord/pages/error/error.dart';
import '../shop/shop.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key, this.onSelect}) : super(key: key);

  final Function(GraphShop selectedShop)? onSelect;

  @override
  Widget build(BuildContext context) {
    String textFilter = '';
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
      body: Query(
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

          List<GraphShop> shops = List<GraphShop>.from(result.data!['getShops']
              .map((model) => GraphShop.fromJson(model)));

          return FutureBuilder<Position>(
            future: Geolocator.getCurrentPosition(),
            builder: (context, snapshot) {
              LatLng myLocation = LatLng(59.9311, 30.3609);
              if (snapshot.hasData) {
                myLocation =
                    LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                shops.sort((a, b) => Geolocator.distanceBetween(
                        a.latitude ?? 0,
                        a.longitude ?? 0,
                        myLocation.latitude,
                        myLocation.longitude)
                    .compareTo(Geolocator.distanceBetween(
                        b.latitude ?? 0,
                        b.longitude ?? 0,
                        myLocation.latitude,
                        myLocation.longitude)));
              }

              return Stack(
                children: [
                  YandexMap(
                    onMapCreated: (controller) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.moveCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(
                                target: Point(
                                    latitude: 59.9311, longitude: 30.3609),
                                zoom: 13)));
                      });
                    },
                    mapObjects: [
                      ...shops.map(
                        (shop) {
                          return Placemark(
                              onTap: (placemark, point) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShopPage(shop: shop)));
                              },
                              opacity: 1,
                              icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                  scale: 1.3,
                                  anchor: Offset(0.5, 1.0),
                                  image: BitmapDescriptor.fromAssetImage(
                                      'assets/3.0x/Pin.png'))),
                              mapId: MapObjectId(shop.iD.toString()),
                              point: Point(
                                  latitude: shop.latitude ?? 0,
                                  longitude: shop.longitude ?? 0));
                        },
                      )
                    ],
                  ),
                  DraggableScrollableSheet(
                    minChildSize: 0.15,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: StatefulBuilder(builder: (context, setState) {
                          return ListView(
                            controller: scrollController,
                            children: [
                              DragHandle(),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() => textFilter = value);
                                  },
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
                              ...shops
                                  .map((shop) => ShopTile(
                                        shop: shop,
                                        onTap: () {
                                          if (onSelect == null) {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShopPage(shop: shop)));
                                          } else {
                                            Navigator.pop(context);
                                            onSelect!(shop);
                                          }
                                        },
                                      ))
                                  .where((element) {
                                return (element.shop.address?.toLowerCase() ??
                                            '')
                                        .contains(textFilter) ||
                                    (element.shop.name?.toLowerCase() ?? '')
                                        .contains(textFilter);
                              })
                            ],
                          );
                        }),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
