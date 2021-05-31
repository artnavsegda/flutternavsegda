import 'package:flutter/material.dart';
import 'src/products.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({
    Key? key,
    required Product product,
  })  : _product = product,
        super(key: key);

  final Product _product;

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
/*     return Text(widget._product.Name); */
    return ListTile(
      leading: FlutterLogo(),
      title: Text(widget._product.Name),
      trailing: Container(
        width: 112,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: new Icon(Icons.remove),
                onPressed: () => setState(() => _counter--)),
            Text(_counter.toString()),
            IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => setState(() => _counter++))
          ],
        ),
      ),
    );
  }
}

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
/*             return Text(widget._products[index].Name); */
            return ProductItem(product: widget._products[index]);
          },
        ));
  }
}
