import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'main.dart';
import 'src/locations.dart';
import 'src/products.dart';
import 'service.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Map<String, Marker> _markers = {};
  List<Machine> _machines = [];

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      GoogleMap(
        myLocationEnabled: true,
        onMapCreated: (GoogleMapController controller) async {
          _machines = await getMachines(context.read<AppModel>().token);
          setState(() {
            _markers.clear();
            for (final machine in _machines) {
              final marker = Marker(
                  markerId: MarkerId(machine.Name),
                  position: LatLng(machine.Latitude, machine.Longitude),
                  infoWindow: InfoWindow(
                    title: machine.Name,
                    snippet: machine.Address,
                  ),
                  onTap: () {
                    print(machine.Name);
                    if (_pageController.hasClients) {
                      _pageController.animateToPage(
                        _machines.indexOf(machine),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  });
              _markers[machine.Name] = marker;
            }
          });
        },
        initialCameraPosition: CameraPosition(
          target: const LatLng(0, 0),
          zoom: 2,
        ),
        markers: _markers.values.toSet(),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            padding: const EdgeInsets.all(8.0),
            height: 210,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: _machines.length,
              itemBuilder: (context, index) {
                return MachineCard(machine: _machines[index]);
              },
            )),
      ),
    ]);
  }
}

class MachineCard extends StatefulWidget {
  const MachineCard({
    Key? key,
    required Machine machine,
  })  : _machine = machine,
        super(key: key);

  final Machine _machine;

  @override
  _MachineCardState createState() => _MachineCardState();
}

class _MachineCardState extends State<MachineCard> {
  bool _scanning = false;
  bool _found = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          title: Text(widget._machine.Name),
          subtitle: Text(
            'Время работы: 10:00:00 - 22:00:00',
            style: TextStyle(color: Colors.black.withOpacity(0.6)),
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                MapsLauncher.launchCoordinates(
                    widget._machine.Latitude, widget._machine.Longitude);
              },
              child: const Text('НАВИГАЦИЯ'),
            ),
            TextButton(
              onPressed: _scanning
                  ? null
                  : () async {
                      if (_found) {
                        var products = await getProducts(
                            context.read<AppModel>().token,
                            widget._machine.IBeaconUDID);
                        print("Knock-knock");
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ServiceScreen(products: products)));
                      } else {
                        setState(() {
                          _scanning = true;
                        });
                        await flutterBeacon.initializeScanning;
                        final regions = <Region>[
                          Region(
                            identifier: 'Fridge',
                            proximityUUID: widget._machine.IBeaconUDID,
                          ),
                        ];

                        Timer(Duration(seconds: 10), () {
                          setState(() {
                            _scanning = false;
                            _found = true;
                          });
                        });
                      }
                    },
              child: Text(_found ? 'ОТКРЫТЬ ЗАМОК' : 'НАЙТИ АВТОМАТ'),
            ),
            Visibility(
              child: CircularProgressIndicator(),
              visible: _scanning,
            )
          ],
        )
      ]),
    );
  }
}
