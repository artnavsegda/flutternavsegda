import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/components/components.dart';
import 'package:nord/login_state.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<FilterState>(builder: (context, model, child) {
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
        body: const GoogleMap(
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(37.42796133580664, -122.085749655962),
            zoom: 14.4746,
          ),
        ),
        bottomNavigationBar: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 28),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          padding: EdgeInsets.only(right: 16)),
                      onPressed: () {
                        model.filter = 'DELIVERY';
                      },
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
                                model.filter == 'DELIVERY'
                                    ? SeverMetropol.Icon_Checkbox_Checked
                                    : SeverMetropol.Icon_Checkbox_Unchecked,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ],
                      )),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.only(right: 16)),
                      onPressed: () {
                        model.filter = 'PICK_UP';
                      },
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
                              model.filter == 'PICK_UP'
                                  ? SeverMetropol.Icon_Checkbox_Checked
                                  : SeverMetropol.Icon_Checkbox_Unchecked,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      )),
                  SizedBox(width: 8),
                  OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.only(right: 16)),
                      onPressed: () {
                        model.filter = 'ALL';
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
                              model.filter == 'ALL'
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
            ),
            ListTile(
              title: const Text('Адмиралтейская набережная, 10а'),
              trailing: Icon(
                SeverMetropol.Icon_Edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                  onPressed: () {}, child: const Text('Выбрать')),
            ),
          ],
        ),
      );
    });
  }
}
