import 'package:flutter/material.dart';
import 'package:beamer/beamer.dart';

// DATA
const List<Map<String, String>> books = [
  {
    'id': '1',
    'title': 'Stranger in a Strange Land',
    'author': 'Robert A. Heinlein',
  },
  {
    'id': '2',
    'title': 'Foundation',
    'author': 'Isaac Asimov',
  },
  {
    'id': '3',
    'title': 'Fahrenheit 451',
    'author': 'Ray Bradbury',
  },
];

// SCREENS
class BooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: ListView(
        children: books
            .map(
              (book) => ListTile(
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
                onTap: () => context.beamToNamed('/books/${book['id']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({required this.book});
  final Map<String, String> book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(book['title']!),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Author: ${book['author']}'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('a');
            Beamer.of(context, root: true).beamToNamed('/test');
          },
        ));
  }
}

class ArticleDetailsScreen extends StatelessWidget {
  const ArticleDetailsScreen({required this.article});
  final Map<String, String> article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['title']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${article['author']}'),
      ),
    );
  }
}

// LOCATIONS
class BooksLocation extends BeamLocation<BeamState> {
  BooksLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/books/:bookId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('books'),
          title: 'Books',
          type: BeamPageType.noTransition,
          child: BooksScreen(),
        ),
        if (state.pathParameters.containsKey('bookId'))
          BeamPage(
            key: ValueKey('book-${state.pathParameters['bookId']}'),
            title: books.firstWhere((book) =>
                book['id'] == state.pathParameters['bookId'])['title'],
            child: BookDetailsScreen(
              book: books.firstWhere(
                  (book) => book['id'] == state.pathParameters['bookId']),
            ),
          ),
      ];
}

// APP
class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int currentIndex = 0;

  final routerDelegates = [
    BeamerDelegate(
      initialPath: '/books',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('books')) {
          return BooksLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  void _setStateListener() => setState(() {});

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Beamer.of(context).addListener(_setStateListener);
  }

  @override
  Widget build(BuildContext context) {
    routerDelegates[0].active = true;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          Beamer(
            routerDelegate: routerDelegates[0],
          ),
          Center(child: Text('Profile'))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(label: 'Books', icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.portrait)),
        ],
        onTap: (index) {
          if (index != currentIndex) {
            setState(() => currentIndex = index);
            routerDelegates[0].update(rebuild: false);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Beamer.of(context).removeListener(_setStateListener);
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    initialPath: '/',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => AppScreen(),
        '/test': (context, state, data) => Scaffold(
              appBar: AppBar(
                title: Text('hello'),
              ),
            ),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}

void main() => runApp(MyApp());
