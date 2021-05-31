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
        body: ListView.builder(
          itemCount: widget._products.length,
          itemBuilder: (context, index) {
            return Text(widget._products[index].Name);
          },
        ));
  }
}
