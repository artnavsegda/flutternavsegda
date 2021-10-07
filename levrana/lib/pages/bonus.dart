import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../gql.dart';

class TransferBonusPage extends StatefulWidget {
  const TransferBonusPage({Key? key, required this.maxAmount})
      : super(key: key);

  final int maxAmount;

  @override
  _TransferBonusPageState createState() => _TransferBonusPageState();
}

enum SearchMode { phone, qr }

class _TransferBonusPageState extends State<TransferBonusPage> {
  double _amount = 0;
  SearchMode? _currentMode = SearchMode.phone;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanned = false;
  late Barcode clientGUID;
  late QRViewController controller;

  Future<void> _openContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final Contact? contact =
            await ContactsService.openDeviceContactPicker();
      } catch (e) {
        //print(e.toString());
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Wrap(
          runSpacing: 8.0,
          children: [
            Text("Подарить бонусы",
                style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700)),
            Text("Укажите количество бонусов"),
            Row(
              children: [
                Expanded(
                  child: Slider(
                      label: "hello",
                      max: widget.maxAmount.toDouble(),
                      value: _amount,
                      onChanged: (newValue) {
                        setState(() {
                          _amount = newValue;
                        });
                      }),
                ),
                Text(_amount.toStringAsFixed(0))
              ],
            ),
            RadioListTile(
              value: SearchMode.phone,
              groupValue: _currentMode,
              title: Text("По номеру телефона"),
              onChanged: (SearchMode? value) {
                setState(() {
                  _currentMode = value;
                });
              },
            ),
            RadioListTile(
              value: SearchMode.qr,
              groupValue: _currentMode,
              title: Text("По QR коду"),
              onChanged: (SearchMode? value) {
                setState(() {
                  _currentMode = value;
                });
              },
            ),
            if (_currentMode == SearchMode.phone)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      inputFormatters: [
                        MaskTextInputFormatter(
                            mask: '+7 (###) ###-##-##',
                            filter: {"#": RegExp(r'[0-9]')})
                      ],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Введите телефон",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.contact_phone),
                    onPressed: () {
                      _openContacts();
                    },
                  )
                ],
              )
            else if (_currentMode == SearchMode.qr)
              if (scanned)
                Query(
                    options: QueryOptions(
                      document: gql(friendFind),
                      variables: {
                        'gUIDorPhone': clientGUID.code,
                      },
                    ),
                    builder: (result, {fetchMore, refetch}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return Text('Loading');
                      }

                      return Text(result.data!['friendFind']['name']);
                    })
              else
                SizedBox(
                  height: 200,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
            Mutation(
                options: MutationOptions(
                  document: gql(friendTransfer),
                  onCompleted: (resultData) {
                    //print(resultData);
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        runMutation({
                          'gUIDorPhone': clientGUID.code,
                          'points': _amount.toInt()
                        });
                      },
                      child: Text("ВВЕДИТЕ ПОЛУЧАТЕЛЯ"));
                })
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      //print(scanData.code);
      setState(() {
        scanned = true;
        clientGUID = scanData;
      });
    });
  }
}
