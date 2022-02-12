import 'package:flutter/material.dart';
import '../sever_metropol_icons.dart';
import '../pages/product/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    required this.productID,
  }) : super(key: key);

  final String productName;
  final String productImage;
  final String productPrice;
  final int productID;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(id: productID)));
                    },
                    child: Image.network(productImage)),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(SeverMetropol.Icon_Add_to_Shopping_Bag,
                        color: Colors.red.shade900),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      primary: Colors.white38,
                      minimumSize: const Size(45, 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    onPressed: () {},
                    icon: Icon(
                      SeverMetropol.Icon_Favorite,
                      color: Colors.red.shade900,
                      size: 12,
                    ),
                    label: const Text(
                      '256',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  top: 0,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      primary: Colors.white38,
                      minimumSize: const Size(45, 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      SeverMetropol.Icon_Star_Rate,
                      color: Color(0xFFD2AB67),
                      size: 12,
                    ),
                    label: const Text(
                      '4.7',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            Text(productName),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: productPrice,
                      style: TextStyle(
                        fontFamily: 'Forum',
                        fontSize: 24,
                      )),
                  TextSpan(text: ' ₽', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
