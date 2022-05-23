import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nord/components/components.dart';
import 'package:nord/sever_metropol_icons.dart';

class GiftBonusModalSheet extends StatelessWidget {
  const GiftBonusModalSheet({
    Key? key,
    required this.maxBonus,
  }) : super(key: key);

  final int maxBonus;

  @override
  Widget build(BuildContext context) {
    var maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          onTap: () => Navigator.pop(context),
          title: Center(
              child: Text(
            'Подарочные бонусы',
          )),
          trailing: Icon(
            SeverMetropol.Icon_Close,
            color: Colors.red[900],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SliderCombo(
                value: 0,
                max: maxBonus,
                onChanged: (newVal) {},
              ),
              SizedBox(height: 12),
              TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [maskFormatter],
                  decoration: InputDecoration(
                    labelText: 'Номер телефона получателя',
                  )),
              SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {}, child: const Text('Подарить бонусы')),
            ],
          ),
        )
      ],
    );
  }
}
