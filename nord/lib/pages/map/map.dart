import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/* class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кондитерские и кафе'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
      ),
    );
  }
} */

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кондитерские и кафе'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(37.42796133580664, -122.085749655962),
              zoom: 14.4746,
            ),
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: Colors.white,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      TextField(),
                      ListTile(title: Text('Невский, 6')),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
