import 'package:flutter/material.dart';
import '../../components/select_address_bottom_sheet.dart';
import '../../components/product_card.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return const SelectAddressBottomSheet();
                  },
                );
              },
              leading: Image.asset(
                  'assets/Illustration Colored Delivery Options.png'),
              title: const Text("Адрес доставки или кафе"),
            ),
            TextField(),
            Text('Выпечка'),
            ProductCard(
              productImage: 'assets/placeholder/product1/Illustration.png',
              productName: 'Торт «Сезонный» с ягодами',
              productPrice: '420 ₽',
            ),
            ProductCard(
              productImage: 'assets/placeholder/product2/Illustration.png',
              productName: 'Анна Павлова',
              productPrice: '315 ₽',
            ),
          ],
        ),
      ),
    );
  }
}
