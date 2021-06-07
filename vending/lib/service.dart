import 'package:flutter/material.dart';
import 'src/products.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.product,
    required this.quantity,
  }) : super(key: key);

  final Product product;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
            'https://app.tseh85.com/service/api/image?PictureId=' +
                product.PictureID.toString()),
      ),
      title: Text(product.Name),
      trailing: Container(
        width: 112,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: new Icon(Icons.remove),
              onPressed: () {},
            ),
            Text(quantity.toString()),
            IconButton(icon: new Icon(Icons.add), onPressed: () => {})
          ],
        ),
      ),
    );
  }
}

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<Product> products;

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<ServiceRow> serviceRows = [];

  @override
  void initState() {
    super.initState();
    //serviceRows = widget.products;
    serviceRows = widget.products
        .map((e) => ServiceRow(Quantity: 0, ProductID: e.ID))
        .toList();
  }

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
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            return ProductItem(
                product: widget.products[index],
                quantity: serviceRows[index].Quantity);
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
