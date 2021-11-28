import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            onTap: () {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return SelectAddressBottomSheet();
                },
              );
            },
            leading:
                Image.asset('assets/Illustration Colored Delivery Options.png'),
            title: Text("Адрес доставки или кафе"),
          ),
          Text("Акции"),
        ],
      ),
    );
  }
}

class SelectAddressBottomSheet extends StatelessWidget {
  const SelectAddressBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('A'),
        ],
      ),
    );
  }
}
