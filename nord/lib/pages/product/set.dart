import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:nord/components/components.dart';
import 'package:nord/components/product_card.dart';
import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/gql.dart';

class SetPage extends StatelessWidget {
  const SetPage({Key? key, required this.modifiers}) : super(key: key);

  final List<GraphModifier> modifiers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              SeverMetropol.Icon_West,
              color: Theme.of(context).colorScheme.primary,
            )),
      ),
      body: Stepper(type: StepperType.horizontal, steps: [
        ...modifiers.map((modifier) => Step(
              title: Text(modifier.caption ?? 'Выберите'),
              content: Wrap(children: [
                ...modifier.products.map((product) => ProductMiniCard(
                      product: product,
                      onTap: () {},
                    ))
              ]),
            )),
      ]),
    );
  }
}

class ProductMiniCard extends StatelessWidget {
  const ProductMiniCard({
    Key? key,
    required this.product,
    required this.onTap,
    this.onReload,
  }) : super(key: key);

  final GraphProduct product;
  final void Function()? onTap;
  final void Function()? onReload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            width: 64,
            height: 64,
            imageUrl: product.picture!,
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: TextStyle(fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${product.prices[0].price.toInt().toString()} ₽',
                            style: TextStyle(
                                fontSize: 16, fontFamilyFallback: ['Roboto'])),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
