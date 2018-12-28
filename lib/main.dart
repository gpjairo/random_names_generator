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

  Widget _buildSuggestions() {
    IndexedWidgetBuilder itemBuilder = (BuildContext context, int index) {
      if (index.isOdd) {
        return new Divider();
      }
      final int i = index ~/ 2;
      if (i >= _wordPairList.length) {
        _wordPairList.addAll(generateWordPairs().take(10));
      }

      return new ListTile(
        title: new Text(
          _wordPairList[i].asPascalCase,
          style: _biggerFont),
      );
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