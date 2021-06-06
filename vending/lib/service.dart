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
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
            'https://app.tseh85.com/service/api/image?PictureId=' +
                widget._product.PictureID.toString()),
      ),
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
    final AlertDialog dialog = AlertDialog(
      title: Text('Уверены ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Text('ДА'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: Text('НЕТ'),
        ),
      ],
    );

    return Scaffold(
        appBar: AppBar(title: Text("Обслуживание")),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          itemCount: widget._products.length,
          itemBuilder: (context, index) {
            return ProductItem(product: widget._products[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
        bottomNavigationBar: TextButton(
          child: Text('ДАЛЕЕ'),
          onPressed: () {
            showDialog<void>(context: context, builder: (context) => dialog);
          },
        ));
  }
}
