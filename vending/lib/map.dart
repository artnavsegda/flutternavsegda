import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'src/locations.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Map<String, Marker> _markers = {};
  List<Machine> _machines = [];

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _machines = await getMachines();
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
  }

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
        onMapCreated: _onMapCreated,
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
                return Card(
                  child: Column(children: [
                    Text(_machines[index].Name),
                  ]),
                );
              },
            )),
      ),
    ]);
  }
}
