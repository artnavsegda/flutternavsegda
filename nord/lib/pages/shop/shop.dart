import 'package:flutter/material.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.asset('assets/placeholder/shop.png'),
              Positioned(
                top: 36,
                left: 12,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(32.0, 32.0),
                      shape: CircleBorder(),
                      primary: Colors.white54, // <-- Button color
                      onPrimary: Colors.red, // <-- Splash color
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset('assets/Icon-Close.png')),
              )
            ],
          ),
          Text('Просвещения, 19 (ТК Норд)'),
          Text('+7 (812) 611-09-27'),
          ListTile(
            onTap: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Center(
                            child: Text(
                          'Режим работы',
                        )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Понедельник'),
                          Text('09:30–20:00'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Вторник'),
                          Text('09:30–20:00'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Среда'),
                          Text('09:30–20:00'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Четверг'),
                          Text('09:30–20:00'),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            subtitle: Text('Режим работы'),
            title: Text('Завтра откроется в 10:00'),
            trailing: Image.asset('assets/Icon-Expand-More.png'),
          ),
          Spacer(),
          ElevatedButton(onPressed: () {}, child: Text('Построить маршрут'))
        ],
      ),
    );
  }
}
