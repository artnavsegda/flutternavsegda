import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'catalog/catalog.dart';
import 'home/home.dart';
import 'more/more.dart';
import 'shopping/shopping.dart';
import 'user/user.dart';

import '../gql.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getReactions),
        ),
        builder: (result, {fetchMore, refetch}) {
          //print(result);

          if (!result.hasException) {
            if (result.isLoading && result.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            List<GraphReaction> reactions = List<GraphReaction>.from(result
                .data!['getReactions']
                .map((model) => GraphReaction.fromJson(model)));

            if (reactions[0].type == 'MESSAGE1') {
              WidgetsBinding.instance!.addPostFrameCallback((_) async {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(reactions[0].message?.caption ?? ""),
                    content: Text(reactions[0].message?.text ?? ""),
                    actions: [
                      Mutation(
                          options: MutationOptions(
                            document: gql(openReactionMessage),
                            onCompleted: (resultData) {
                              refetch!();
                            },
                          ),
                          builder: (runMutation, mutationResult) {
                            return TextButton(
                              onPressed: () async {
                                await launch(reactions[0].message?.uRL ?? "");
                                runMutation(
                                    {'messageID': reactions[0].message?.iD});
                                Navigator.pop(context, 'OK');
                              },
                              child: Text(reactions[0].message?.button ?? ""),
                            );
                          }),
                    ],
                  ),
                );
              });
            }
          }

          return Scaffold(
            body: TabBarView(
              controller: _tabController,
              children: [
                HomePage(),
                const CatalogNavigator(),
                const ShoppingPage(),
                const UserPage(),
                const MorePage(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.07),
                    blurRadius: 100.0,
                    offset: Offset(0.0, -27),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.0417275),
                    blurRadius: 22.3363,
                    offset: Offset(0.0, -6.0308),
                  ),
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.0282725),
                    blurRadius: 6.6501,
                    offset: Offset(0.0, -1.79553),
                  )
                ],
              ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index) {
                  _tabController.animateTo(index);
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedItemColor: Colors.green[800],
                unselectedItemColor: Colors.black,
                currentIndex: _selectedIndex,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/ic-24/icons-home.png')),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                        AssetImage('assets/ic-24/icon-24-catalog-v3.png')),
                    label: 'Catalog',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                        AssetImage('assets/ic-24/icon-24-shopping.png')),
                    label: 'Shopping',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        ImageIcon(AssetImage('assets/ic-24/icon-24-user.png')),
                    label: 'User',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(AssetImage('assets/ic-24/icons-more.png')),
                    label: 'More',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
