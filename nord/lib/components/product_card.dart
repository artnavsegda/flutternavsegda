import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:nord/gql.dart';
import 'package:nord/sever_metropol_icons.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductPage(id: productID)));
                  },
                  child: CachedNetworkImage(
                    imageUrl: productImage,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: const Color(0xFFECECEC),
                      highlightColor: Colors.white,
                      child: Container(
                        color: const Color(0xFFECECEC),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: const Color(0xFFECECEC),
                      child: Center(
                        child: const Icon(Icons.no_photography),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Mutation(
                    options: MutationOptions(
                      document: gql(cartAdd),
                      onCompleted: (resultData) {
                        //print(resultData);

                        Fluttertoast.showToast(
                            msg: "Товар добавлен в корзину",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1);
                      },
                    ),
                    builder: (runMutation, result) {
                      return IconButton(
                        onPressed: () {
                          runMutation({'productID': productID});
                        },
                        icon: Icon(SeverMetropol.Icon_Add_to_Shopping_Bag,
                            color: Theme.of(context).colorScheme.primary),
                      );
                    },
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
                      color: Theme.of(context).colorScheme.primary,
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
          ),
          Text(productName),
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: productPrice,
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: ' ₽',
                    style: TextStyle(fontFamily: 'Noto Sans', fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
