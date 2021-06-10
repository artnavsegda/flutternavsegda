import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const String getHome2 = """
query getClientInfo {
  getClientInfo {
    points,
  }
}

query getActions {
  getActions {
    name
  }
}

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

const String getHome = """
query getActions {
  getActions {
    name
  }
}

query getClientInfo {
  getClientInfo {
    points,
  }
}
""";

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(getHome), // this is the query string you just created
        ),
        builder: (result, {fetchMore, refetch}) {
          print(result.data);
          return Column(
            children: [
              Text("Hello"),
              //Text(result.data!['getClientInfo']['points'].toString()),
              /* ListView.separated(
                itemCount: result.data!['getActions'].length,
                itemBuilder: (context, index) {
                  return Text(result.data!['getActions'][index]['name']);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    indent: 20,
                    endIndent: 20,
                  );
                },
              ), */
            ],
          );
        });
  }
}
