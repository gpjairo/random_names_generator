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
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Startup names generator'),
        ),
        body: new Center(
          child: new RandomWords()
        )
      )
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _wordPairList = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _favouritedWordPairs = new Set<WordPair>();

  Widget _buildRow(WordPair wordPair) {
    final isFavourited = FavouriteWordPairsRepository.getRepository().contains(wordPair);
    final icon = isFavourited ? Icons.favorite : Icons.favorite_border;
    final color = isFavourited ? Colors.red : null;
    final GestureTapCallback onTapCallback = () {
      setState(() { // To refresh the UI
        FavouriteWordPairsRepository.getRepository().toggleFavourite(wordPair);
      });
    };

    return new ListTile(
      title: new Text(
        wordPair.asPascalCase,
        style: _biggerFont),
      trailing: new Icon(icon, color:color),
      onTap: onTapCallback,
    );
  }

  Widget _buildSuggestions() {
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

    return new ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemBuilder: itemBuilder,
    );
  }

  @override
  Widget build(BuildContext context) {  
    return _buildSuggestions();
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
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