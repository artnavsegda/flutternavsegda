import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../shop/shop.dart';
import '../../gql.dart';

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
          return Scaffold(
            appBar: AppBar(),
            body: Center(
                child: Text(
              result.exception.toString(),
            )),
          );
        }

        if (result.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<GraphShop> shops = List<GraphShop>.from(
            result.data!['getShops'].map((model) => GraphShop.fromJson(model)));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Кондитерские и кафе'),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset('assets/Icon-West.png')),
          ),
          body: Stack(
            children: [
              GoogleMap(
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
                markers: shops.map(
                  (shop) {
                    return Marker(
                        markerId: MarkerId(shop.name),
                        position:
                            LatLng(shop.latitude ?? 0, shop.longitude ?? 0));
                  },
                ).toSet(),
              ),
              SizedBox.expand(
                child: DraggableScrollableSheet(
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      color: Colors.white,
                      child: ListView(
                        controller: scrollController,
                        children: [
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
                          ...shops
                              .map(
                                (shop) {
                                  return ListTile(
                                    isThreeLine: true,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ShopPage(shop: shop)));
                                    },
                                    title: Text(shop.address ?? 'Невский, 6'),
                                    subtitle: const Text(
                                        'Сегодня открыто до 22:00\nАдмиралтейская'),
                                    trailing: Image.asset(
                                        'assets/Icon-Direction.png'),
                                  );
                                },
                              )
                              .toList()
                              .cast<Widget>(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
