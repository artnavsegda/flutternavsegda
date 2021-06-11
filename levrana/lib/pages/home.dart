import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document:
              gql(getActions), // this is the query string you just created
        ),
        builder: (result, {fetchMore, refetch}) {
          print(result.data);
          return PageView.builder(
            itemCount: result.data!['getActions'].length,
            itemBuilder: (context, index) {
              return Text(result.data!['getActions'][index]['name']);
            },
          );
        });
  }
}
