import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/shop_tile.dart';

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
                  builder: (context, scrollController) {
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
                          ...shops.map((shop) => ShopTile(shop: shop)),
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
