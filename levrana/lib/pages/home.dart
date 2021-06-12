import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'user.dart';

const String getActions = """
query getActions {
  getActions {
    iD
    name
    picture
  }
}
""";

const String getTopBlocks = """
query getTopBlocks {
  getTopBlocks
  {
    name
    products {
      name
    }
  }
}
""";

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _controller = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Query(
              options: QueryOptions(document: gql(getClientInfo)),
              builder: (result, {fetchMore, refetch}) {
                return Text(result.data!['getClientInfo']['points'].toString());
              }),
          Query(
              options: QueryOptions(document: gql(getActions)),
              builder: (result, {fetchMore, refetch}) {
                print(result.data);
                return Container(
                  height: 160,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: result.data!['getActions'].length,
                    itemBuilder: (context, index) {
                      //return Text(result.data!['getActions'][index]['name']);
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Image.network(
                            result.data!['getActions'][index]['picture']),
                      );
                    },
                  ),
                );
              }),
          Text("Hello")
        ],
      ),
    );
    //return Column(children: [
/*       Query(
          options: QueryOptions(document: gql(getClientInfo)),
          builder: (result, {fetchMore, refetch}) {
            return Text(result.data!['getClientInfo']['points'].toString());
          }), */
/*       Query(
          options: QueryOptions(document: gql(getActions)),
          builder: (result, {fetchMore, refetch}) {
            print(result.data);
            return Container(
              height: 160,
              child: PageView.builder(
                itemCount: result.data!['getActions'].length,
                itemBuilder: (context, index) {
                  //return Text(result.data!['getActions'][index]['name']);
                  return Image.network(
                      result.data!['getActions'][index]['picture']);
                },
              ),
            );
          }), */
/*     return Query(
        options: QueryOptions(document: gql(getTopBlocks)),
        builder: (result, {fetchMore, refetch}) {
          print(result.data);
          return ListView.separated(
            itemCount: result.data!['getTopBlocks'].length,
            itemBuilder: (context, index) {
              return Text(result.data!['getTopBlocks'][index]['name']);
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 1,
                indent: 20,
                endIndent: 20,
              );
            },
          );
        }); */
    //]);
  }
}
