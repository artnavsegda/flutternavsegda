import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';
import 'package:nord/login_state.dart';
import 'package:nord/pages/map/map.dart';
import 'delivery_address.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
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
      body: Stack(children: [
        GoogleMap(
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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey),
                                padding: EdgeInsets.only(right: 16)),
                            onPressed: () {},
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
                                      SeverMetropol.Icon_Checkbox_Unchecked,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              ],
                            )),
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.only(right: 16)),
                            onPressed: () {},
                            label: const Text('Самовывоз'),
                            icon: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Image.asset(
                                      'assets/Illustration-Colored-Cafe.png'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    SeverMetropol.Icon_Checkbox_Unchecked,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.only(right: 16)),
                            onPressed: () {},
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
                                    SeverMetropol.Icon_Checkbox_Unchecked,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }
}
