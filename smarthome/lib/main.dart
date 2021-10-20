import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          LightPage(),
          Text("2"),
          Text("3"),
          Text("4"),
          Text("5"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _tabController.animateTo(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ac_unit_outlined),
            label: "Свет",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm),
            label: "Шторы",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: "Климат",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units),
            label: "Медиа",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Сценарии",
          )
        ],
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

class LightPage extends StatelessWidget {
  const LightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: [
        RoomCard(image: 'assets/bedroom.jpg'),
        RoomCard(image: 'assets/garage.jpg'),
        RoomCard(image: 'assets/kidsroom.jpg'),
        RoomCard(image: 'assets/kitchen.jpg'),
        RoomCard(image: 'assets/cabinet.jpg'),
      ],
    );
  }
}

class RoomCard extends StatelessWidget {
  const RoomCard({
    required this.image,
    Key? key,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
          child: Image.asset(image, fit: BoxFit.cover, width: 1000.0)),
    );
  }
}
