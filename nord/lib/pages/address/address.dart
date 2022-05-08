import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';
import 'package:nord/login_state.dart';
import 'package:nord/pages/map/map.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'delivery_address.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late FilterState copyState;

  Set<Marker> markers = <Marker>{};

  @override
  void initState() {
    super.initState();
    copyState = FilterState.from(context.read<FilterState>());
  }

  Widget chooser(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 16),
          OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey),
                  padding: EdgeInsets.only(right: 16)),
              onPressed: () {
                setState(() => copyState.filter = 'DELIVERY');
              },
              label: const Text('Доставка'),
              icon: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:
                        Image.asset('assets/Illustration-Colored-Delivery.png'),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        copyState.filter == 'DELIVERY'
                            ? SeverMetropol.Icon_Checkbox_Checked
                            : SeverMetropol.Icon_Checkbox_Unchecked,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              )),
          SizedBox(width: 8),
          OutlinedButton.icon(
              style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.only(right: 16)),
              onPressed: () {
                setState(() => copyState.filter = 'PICK_UP');
              },
              label: const Text('Самовывоз'),
              icon: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset('assets/Illustration-Colored-Cafe.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      copyState.filter == 'PICK_UP'
                          ? SeverMetropol.Icon_Checkbox_Checked
                          : SeverMetropol.Icon_Checkbox_Unchecked,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )),
          SizedBox(width: 8),
          OutlinedButton.icon(
              style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.only(right: 16)),
              onPressed: () {
                setState(() {
                  copyState.filter = 'ALL';
                  markers = {};
                });
              },
              label: const Text('Все товары'),
              icon: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                        'assets/Illustration-Colored-Delivery-Options.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      copyState.filter == 'ALL'
                          ? SeverMetropol.Icon_Checkbox_Checked
                          : SeverMetropol.Icon_Checkbox_Unchecked,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget mapStack({required BuildContext context}) {
    return Stack(children: [
      GoogleMap(
        markers: markers,
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
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
                DragHandle(),
                SizedBox(height: 8),
                chooser(context),
                if (copyState.filter == 'DELIVERY')
                  Query(
                      options: QueryOptions(document: gql(getClientInfo)),
                      builder: (result, {fetchMore, refetch}) {
                        if (result.isLoading && result.data == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (result.hasException) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        GraphClientFullInfo userInfo =
                            GraphClientFullInfo.fromJson(
                                result.data!['getClientInfo']);

                        Set<Marker> newMarkers = userInfo.deliveryAddresses.map(
                          (deliveryAddress) {
                            return Marker(
                                markerId:
                                    MarkerId(deliveryAddress.iD.toString()),
                                position: LatLng(deliveryAddress.latitude,
                                    deliveryAddress.longitude));
                          },
                        ).toSet();

                        if (!setEquals(newMarkers, markers))
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            setState(() {
                              markers = newMarkers;
                            });
                          });

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...userInfo.deliveryAddresses.map(
                              (e) => ListTile(
                                title: Text(e.description ?? 'WTF'),
                                subtitle: Text(e.address),
                              ),
                            ),
                          ],
                        );
                      })
                else if (copyState.filter == 'PICK_UP')
                  Query(
                    options: QueryOptions(
                      document: gql(getShops),
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (result.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<GraphShop> shops = List<GraphShop>.from(result
                          .data!['getShops']
                          .map((model) => GraphShop.fromJson(model)));

                      return FutureBuilder<Position>(
                        future: Geolocator.getCurrentPosition(),
                        builder: (context, snapshot) {
                          LatLng myLocation = LatLng(59.9311, 30.3609);
                          if (snapshot.hasData) {
                            myLocation = LatLng(snapshot.data!.latitude,
                                snapshot.data!.longitude);
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

                          return Column(
                            children: [
                              ...shops.map((shop) => ShopTile(
                                    shop: shop,
                                    onTap: () {},
                                  ))
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: const Text('Адрес доставки или кафе'),
      ),
      body: mapStack(context: context),
    );
  }
}

class ShopTile extends StatelessWidget {
  const ShopTile({
    Key? key,
    this.onTap,
    required this.shop,
  }) : super(key: key);

  final GraphShop shop;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: onTap,
      title: Text(
        shop.address ?? 'Нет адреса',
        style: TextStyle(color: Colors.red[900]),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Сегодня открыто до 22:00'),
          Wrap(
            children: [
              ...shop.metroStations
                  .map((metroStation) => Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: hexToColor(metroStation.colorLine),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(metroStation.stationName),
                          SizedBox(width: 8),
                        ],
                      ))
                  .toList()
                  .cast<Widget>(),
            ],
          ),
        ],
      ),
      trailing: Icon(
        SeverMetropol.Icon_Direction,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
