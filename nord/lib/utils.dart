import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

String periodDate(int? dateStart, int? dateEnd) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime dateStartDate = DateTime.fromMillisecondsSinceEpoch(dateStart ?? 0);
  String dateStartString = DateFormat.MMMMd('ru_RU').format(dateStartDate);
  DateTime dateEndDate = DateTime.fromMillisecondsSinceEpoch(dateEnd ?? 0);
  String dateEndString = DateFormat.MMMMd('ru_RU').format(dateEndDate);

  if (dateStart == null && dateEnd == null)
    return '';
  else if (dateStart == null)
    return 'Только до $dateEndString';
  else if (dateEnd == null)
    return 'C $dateStartString';
  else
    return '$dateStartString–$dateEndString';
}

void showErrorAlert(BuildContext context, String error) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Ошибка'),
      content: SingleChildScrollView(
          child: Text(
        '$error',
        //style: TextStyle(fontSize: 10),
      )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
