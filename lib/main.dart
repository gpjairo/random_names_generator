import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new WordPairListPage()
    );
  }
}

class WordPairListPage extends StatefulWidget {
  @override
  WordPairListPageState createState() => new WordPairListPageState();
}

class WordPairListPageState extends State<WordPairListPage> {
  final List<WordPair> _wordPairList = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(WordPair wordPair) {
    final GestureTapCallback onTapCallback = () {
      setState(() { // To refresh the UI
        FavouriteWordPairsRepository.getRepository().toggleFavourite(wordPair);
      });
    };
    return new WordPairListRow(wordPair, onTapCallback);
  }

  @override
  Widget build(BuildContext context) { 
    final _navigateToFavouritesScreen = () {
      Navigator.of(context).push(
        new MaterialPageRoute<void>(builder: (context) => FavouritesListPage()),
      );
    };
      
    IndexedWidgetBuilder itemBuilder = (BuildContext context, int index) {
      if (index.isOdd) {
        return new Divider();
      }
      final int i = index ~/ 2;
      if (i >= _wordPairList.length) {
        _wordPairList.addAll(generateWordPairs().take(10));
      }
      return _buildRow(_wordPairList[i]);
    };

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Startup names generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _navigateToFavouritesScreen),
        ],
      ),
      body: new Center(
        child: new ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemBuilder: itemBuilder,
        )
      )
    );
  }
}

class FavouritesListPage extends StatefulWidget {
  @override
  FavouritesListPageState createState() => new FavouritesListPageState();
}
class FavouritesListPageState extends State<FavouritesListPage> {
  final List<WordPair> _wordPairList = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

    Widget _buildRow(WordPair wordPair) {
      final GestureTapCallback onTapCallback = () {
        setState(() { // To refresh the UI
          FavouriteWordPairsRepository.getRepository().toggleFavourite(wordPair);
        });
      };
      return new WordPairListRow(wordPair, onTapCallback);
    }

  @override
  Widget build(BuildContext context) {  
    List<WordPair> favouritesList = FavouriteWordPairsRepository.getRepository().getList();
    IndexedWidgetBuilder itemBuilder = (BuildContext context, int index) {
      return _buildRow(favouritesList[index]);
    };

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Favourites'),
      ),
      body: new Center(
        child: new ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: favouritesList.length,
          itemBuilder: itemBuilder,
        )
      )
    );
  }
}

class WordPairListRow extends StatelessWidget {
  WordPairListRow(this._wordPair, this._actionCallback);
  final WordPair _wordPair;
  final GestureTapCallback _actionCallback;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    final isFavourited = FavouriteWordPairsRepository.getRepository().contains(_wordPair);
    final icon = isFavourited ? Icons.favorite : Icons.favorite_border;
    final color = isFavourited ? Colors.red : null;

    return new ListTile(
      title: new Text(
        _wordPair.asPascalCase,
        style: _biggerFont),
      trailing: new Icon(icon, color:color),
      onTap: _actionCallback,
    );
  }
}


class FavouriteWordPairsRepository {
  static final FavouriteWordPairsRepository _repo = new FavouriteWordPairsRepository();
  static FavouriteWordPairsRepository getRepository() {
    return _repo;
  }

  final Set<WordPair> _wordPairs = new Set<WordPair>();
  void add (WordPair wordPair) {
    _wordPairs.add(wordPair);
  }
  void remove (WordPair wordPair) {
    _wordPairs.remove(wordPair);
  }
  bool contains (WordPair wordPair) {
    return _wordPairs.contains(wordPair);
  }
  void toggleFavourite (WordPair wordPair) {
    if (this.contains(wordPair)) {
      this.remove(wordPair);
    } else { 
      this.add(wordPair); 
    }
  }
  int count () {
    return _wordPairs.length;
  }
  List<WordPair> getList() {
    return _wordPairs.toList();
  }
}