import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:phone_number/phone_number.dart';

import '../../gql.dart';

class TransferBonusPage extends StatefulWidget {
  const TransferBonusPage({Key? key, required this.maxAmount})
      : super(key: key);

  final int maxAmount;

  @override
  _TransferBonusPageState createState() => _TransferBonusPageState();
}

enum SearchMode { phone, qr }

class _TransferBonusPageState extends State<TransferBonusPage> {
  bool phoneNumberIsCorrect = false;
  double _amount = 0;
  SearchMode? _currentMode = SearchMode.phone;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanned = false;
  late Barcode clientGUID;
  late QRViewController controller;
  final textController = TextEditingController();

  var maskFormatter = MaskTextInputFormatter(
      mask: '+7 ### ###-##-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  Future<String?> _openContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      try {
        final Contact? contact =
            await ContactsService.openDeviceContactPicker();
        //print(contact?.phones!.first.value);
        return contact?.phones!.first.value;
      } catch (e) {
        //print(e.toString());
      }
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
    return "no";
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
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold)),
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
                      onChanged: (value) async {
                        try {
                          PhoneNumber phoneNumber =
                              await PhoneNumberUtil().parse(value);
                          setState(() {
                            phoneNumberIsCorrect = true;
                          });
                        } catch (e) {
                          setState(() {
                            phoneNumberIsCorrect = false;
                          });
                        }
                      },
                      controller: textController,
                      inputFormatters: [maskFormatter],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Введите телефон",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.contact_phone),
                    onPressed: () async {
                      String? phone = await _openContacts();
                      PhoneNumber phoneNumber =
                          await PhoneNumberUtil().parse(phone!);
                      print(phoneNumber.toString());
                      textController.value =
                          TextEditingValue(text: phoneNumber.international);
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
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          setState(() {
                            scanned = false;
                          });
                        });
                        return Center(child: CircularProgressIndicator());
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                result.data!['friendFind']['picture']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(result.data!['friendFind']['name']),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                scanned = false;
                              });
                            },
                          )
                        ],
                      );
                    })
              else
                AspectRatio(
                  aspectRatio: 1.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
            Mutation(
                options: MutationOptions(
                  document: gql(friendTransfer),
                  onCompleted: (resultData) {
                    print(resultData);
                    if (resultData['friendTransfer']['code'] != 0) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Информация'),
                          content: Text(
                              resultData['friendTransfer']['errorMessage']),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                builder: (runMutation, result) {
                  return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                      onPressed: phoneNumberIsCorrect || scanned
                          ? () async {
                              if (_currentMode == SearchMode.phone) {
                                try {
                                  PhoneNumber phoneNumber =
                                      await PhoneNumberUtil()
                                          .parse(textController.text);
                                  print('7' + phoneNumber.nationalNumber);
                                  runMutation({
                                    'gUIDorPhone':
                                        '7' + phoneNumber.nationalNumber,
                                    'points': _amount.toInt()
                                  });
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Ошибка'),
                                      content: Text("Неправильный номер"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              } else if (_currentMode == SearchMode.qr) {
                                runMutation({
                                  'gUIDorPhone': clientGUID.code,
                                  'points': _amount.toInt()
                                });
                              }
                            }
                          : null,
                      child: Text(phoneNumberIsCorrect || scanned
                          ? "ПОДАРИТЬ"
                          : "ВВЕДИТЕ ПОЛУЧАТЕЛЯ"));
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
