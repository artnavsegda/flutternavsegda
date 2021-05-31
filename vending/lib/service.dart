import 'package:flutter/material.dart';
import 'src/products.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({
    Key? key,
    required List<Product> products,
  })  : _products = products,
        super(key: key);

  final List<Product> _products;

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Обслуживание")),
      body: Center(
        child: Text("Full-screen dialog"),
      ),
    );
  }
}
