import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';
import 'package:nord/login_state.dart';
import 'package:nord/pages/map/map.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:nord/gql.dart';
import 'package:nord/utils.dart';
import 'delivery_address.dart';
import 'enter_address.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  late String filter = 'ALL';
  late GraphShop? activeShop;
  late GraphDeliveryAddress? activeAddress;
  GlobalKey _mapKey = new GlobalKey();
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    filter = context.read<FilterState>().filter;
    activeShop = context.read<FilterState>().activeShop;
    activeAddress = context.read<FilterState>().activeAddress;
  }

  Widget chooser(BuildContext context) {
    return SingleChildScrollView(
      key: _globalKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 16),
          if (context.read<LoginState>().loggedIn) ...[
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey),
                    padding: EdgeInsets.only(right: 16)),
                onPressed: context.read<LoginState>().loggedIn
                    ? () {
                        setState(() => filter = 'DELIVERY');
                      }
                    : null,
                label: const Text('Доставка'),
                icon: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                          'assets/Illustration-Colored-Delivery.png'),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          filter == 'DELIVERY'
                              ? SeverMetropol.Icon_Checkbox_Checked
                              : SeverMetropol.Icon_Checkbox_Unchecked,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                  ],
                )),
            SizedBox(width: 8),
          ],
          OutlinedButton.icon(
              style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.only(right: 16)),
              onPressed: () {
                setState(() => filter = 'PICK_UP');
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
                      filter == 'PICK_UP'
                          ? SeverMetropol.Icon_Checkbox_Checked
                          : SeverMetropol.Icon_Checkbox_Unchecked,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )),
/*           SizedBox(width: 8),
          OutlinedButton.icon(
              style:
                  OutlinedButton.styleFrom(padding: EdgeInsets.only(right: 16)),
              onPressed: () {
                setState(() {
                  filter = 'ALL';
                });
                context.read<FilterState>().update(newFilter: filter);
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
                      filter == 'ALL'
                          ? SeverMetropol.Icon_Checkbox_Checked
                          : SeverMetropol.Icon_Checkbox_Unchecked,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              )), */
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget mapStack(
      {required BuildContext context,
      List<Widget> children = const <Widget>[],
      List<Placemark> markers = const <Placemark>[]}) {
    return Stack(children: [
      FutureBuilder<Position>(
          future: Geolocator.getCurrentPosition(),
          builder: (context, snapshot) {
            LatLng myLocation = LatLng(59.9311, 30.3609);
            if (snapshot.hasData) {
              myLocation =
                  LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
            }
            return YandexMap(
                //key: _mapKey,
                onMapCreated: (controller) async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.moveCamera(CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target:
                                Point(latitude: 59.9311, longitude: 30.3609),
                            zoom: 13)));
                  });
                  Position myPosition = await Geolocator.getCurrentPosition();
                  controller.moveCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: Point(
                              latitude: myPosition.latitude,
                              longitude: myPosition.longitude),
                          zoom: 13)));
                },
                mapObjects: [...markers]);
          }),
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
                ...children,
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
      body: filter == 'DELIVERY'
          ? Query(
              options: QueryOptions(
                fetchPolicy: FetchPolicy.networkOnly,
                document: gql(getClientInfo),
              ),
              builder: (result, {fetchMore, refetch}) {
                if (result.isLoading && result.data == null) {
                  return mapStack(context: context);
                }

                if (result.hasException) {
                  return mapStack(context: context);
                }

                if (result.data!['getClientInfo'] == null) {
                  return mapStack(context: context);
                }

                GraphClientFullInfo userInfo =
                    GraphClientFullInfo.fromJson(result.data!['getClientInfo']);

                return mapStack(
                  context: context,
                  markers: [
                    ...userInfo.deliveryAddresses.map(
                      (deliveryAddress) {
                        return Placemark(
                            onTap: (placemark, point) {
                              activeAddress = deliveryAddress;
                              context.read<FilterState>().update(
                                  newActiveAddress: deliveryAddress,
                                  newFilter: filter);
                              Navigator.pop(context);
                            },
                            opacity: 1,
                            icon: PlacemarkIcon.single(PlacemarkIconStyle(
                                scale: 1.3,
                                anchor: Offset(0.5, 1.0),
                                image: BitmapDescriptor.fromAssetImage(
                                    'assets/3.0x/Pin.png'))),
                            mapId: MapObjectId(deliveryAddress.iD.toString()),
                            point: Point(
                                latitude: deliveryAddress.latitude,
                                longitude: deliveryAddress.longitude));
                      },
                    )
                  ],
                  children: [
                    ...userInfo.deliveryAddresses.map(
                      (deliveryAddress) => ListTile(
                        title: Text(deliveryAddress.description ?? 'WTF'),
                        subtitle: Text(deliveryAddress.address),
                        onTap: () {
                          activeAddress = deliveryAddress;
                          context.read<FilterState>().update(
                              newActiveAddress: deliveryAddress,
                              newFilter: filter);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GradientButton(
                        child: Text('Добавить новый адрес'),
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnterAddress()));
                          refetch!();
                        },
                      ),
                    ),
                  ],
                );
              })
          : filter == 'PICK_UP'
              ? Query(
                  options: QueryOptions(
                    document: gql(getShops),
                  ),
                  builder: (result, {fetchMore, refetch}) {
                    if (result.hasException) {
                      return mapStack(context: context);
                    }

                    if (result.isLoading) {
                      return mapStack(context: context);
                    }

                    if (result.data!['getShops'] == null) {
                      return mapStack(context: context);
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

                        return mapStack(
                          context: context,
                          markers: [
                            ...shops.map(
                              (shop) {
                                return Placemark(
                                    onTap: (placemark, point) {
                                      activeShop = shop;
                                      context.read<FilterState>().update(
                                          newActiveShop: shop,
                                          newFilter: filter);
                                      Navigator.pop(context);
                                    },
                                    opacity: 1,
                                    icon: PlacemarkIcon.single(
                                        PlacemarkIconStyle(
                                            scale: 1.3,
                                            anchor: Offset(0.5, 1.0),
                                            image:
                                                BitmapDescriptor.fromAssetImage(
                                                    'assets/3.0x/Pin.png'))),
                                    mapId: MapObjectId(shop.iD.toString()),
                                    point: Point(
                                        latitude: shop.latitude ?? 0,
                                        longitude: shop.longitude ?? 0));
                              },
                            )
                          ],
                          children: [
                            ...shops.map((shop) => ShopTile(
                                  shop: shop,
                                  onTap: () {
                                    activeShop = shop;
                                    context.read<FilterState>().update(
                                        newActiveShop: shop, newFilter: filter);
                                    Navigator.pop(context);
                                  },
                                ))
                          ],
                        );
                      },
                    );
                  },
                )
              : mapStack(context: context),
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
    );
  }
}
