import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:nord/sever_metropol_icons.dart';
import 'package:nord/utils.dart';
import 'package:nord/gql.dart';
import 'package:nord/components/components.dart';

class CartTile extends StatefulWidget {
  const CartTile({
    Key? key,
    required this.item,
    required this.reload,
  }) : super(key: key);

  final GraphCartRow item;
  final Function() reload;

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Mutation(
        options: MutationOptions(
            document: gql(cartDelete),
            onError: (error) {
              showErrorAlert(context, '$error');
            },
            onCompleted: (resultData) {
              widget.reload();
            }),
        builder: (runMutation, result) {
          return Slidable(
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.picture!.isNotEmpty)
                    CachedNetworkImage(
                      width: 64,
                      height: 64,
                      imageUrl: widget.item.picture!,
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
                    )
                  else
                    Container(
                      width: 64,
                      height: 64,
                      color: const Color(0xFFECECEC),
                      child: Center(
                        child: const Icon(Icons.no_photography),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(widget.item.productName,
                                      style: TextStyle(fontSize: 16)),
                                  if (widget.item.modifiers != null)
                                    Text(widget.item.modifiers ?? '',
                                        style: TextStyle(color: Colors.grey)),
                                  if (widget.item.message != null)
                                    Row(
                                      children: [
                                        widget.item.typeMessage == 'WARNING'
                                            ? Icon(
                                                SeverMetropol.Icon_Info,
                                                color: Colors.blue[900],
                                              )
                                            : Icon(
                                                SeverMetropol.Icon_Notification,
                                                color: Colors.red[900],
                                              ),
                                        Text(widget.item.message ?? '',
                                            style: TextStyle(
                                                color:
                                                    widget.item.typeMessage ==
                                                            'WARNING'
                                                        ? Colors.blue[900]
                                                        : Colors.red[900])),
                                      ],
                                    ),
                                  Mutation(
                                      options: MutationOptions(
                                          document: gql(cartEdit),
                                          onError: (error) {
                                            showErrorAlert(context, '$error');
                                          },
                                          onCompleted: (resultData) {
                                            print(resultData);
                                            if (resultData != null) {
                                              GraphBasisResult nordBasisResult =
                                                  GraphBasisResult.fromJson(
                                                      resultData['cartEdit']);
                                              if (nordBasisResult.result == 0) {
                                                widget.reload();
                                              } else {
                                                showErrorAlert(
                                                    context,
                                                    nordBasisResult
                                                            .errorMessage ??
                                                        '');
                                              }
                                            }
                                          }),
                                      builder: (runMutation, result) {
                                        return Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                runMutation({
                                                  'rowID': widget.item.rowID,
                                                  'quantity':
                                                      widget.item.quantity - 1,
                                                });
                                              },
                                              icon: Icon(
                                                  SeverMetropol.Icon_Remove,
                                                  color: Colors.red[900]),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: 32,
                                              height: 24,
                                              child: Text(
                                                  '${widget.item.quantity.round()}'),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                runMutation({
                                                  'rowID': widget.item.rowID,
                                                  'quantity':
                                                      widget.item.quantity + 1,
                                                });
                                              },
                                              icon: Icon(SeverMetropol.Icon_Add,
                                                  color: Colors.red[900]),
                                            ),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${widget.item.amount.floor()} ₽',
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans',
                                      fontSize: 16,
                                      fontFamilyFallback: ['Roboto'],
                                    )),
                                if (widget.item.oldAmount != null)
                                  CustomPaint(
                                    painter: RedLine(),
                                    child: Text(
                                        '${widget.item.oldAmount!.floor()}  ₽',
                                        style: TextStyle(
                                            fontFamily: 'Noto Sans',
                                            color: Colors.grey,
                                            fontFamilyFallback: ['Roboto'])),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            endActionPane: ActionPane(
              extentRatio: 0.2,
              dismissible: DismissiblePane(onDismissed: () {
                setState(() {
                  _visible = false;
                });
                runMutation({
                  'rowIDs': [widget.item.rowID]
                });
              }),
              motion: const DrawerMotion(),
              children: [
                SlidableAction(
                  autoClose: false,
                  onPressed: (context) {
                    Slidable.of(context)!
                        .dismiss(ResizeRequest(Duration(milliseconds: 300), () {
                      setState(() {
                        _visible = false;
                      });
                      runMutation({
                        'rowIDs': [widget.item.rowID]
                      });
                    }));
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: SeverMetropol.Icon_Delete,
                )
              ],
            ),
          );
        });
  }
}
