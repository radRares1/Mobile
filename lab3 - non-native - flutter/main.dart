import 'package:flutter/material.dart';
import 'package:recepie_flutter/domain/Recepie.dart';
import 'package:recepie_flutter/domain/RecepieAssetScreen.dart';
import 'package:recepie_flutter/domain/AddScreen.dart';
import 'package:recepie_flutter/repos/InMemRepository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  InMemRepository repo = new InMemRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(body: HomeScreen(repo)));
    //new Scaffold(body: ListScreen(repo)));
  }
}

class HomeScreen extends StatelessWidget {
  InMemRepository repo;

  HomeScreen(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow,
        body: Column(
          children: [
            Spacer(flex: 1),
            Image.asset('assets/images/pie.png'),
            SizedBox(height: 50),
            Container(
              alignment: Alignment.center,
              color: Colors.yellow,

              child: Text(
                "Recepie Ark",
                style: TextStyle(fontSize: 50,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(flex: 1),
            FlatButton(
              height: 50,
              minWidth: 100,
              color: Colors.purple,
              child: Text("See recepies", style: TextStyle(color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  // Create the SelectionScreen in the next step.
                  MaterialPageRoute(builder: (context) => ListScreen(repo)),
                );
              },
            ),
            Spacer(flex: 1)],
        ));
  }
}

class ListScreen extends StatelessWidget {
  InMemRepository repo;

  ListScreen(this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Current Recepies:'),
      ),
      backgroundColor: Colors.yellow,
      body: Center(
        //child: const Text('Hello World'),
        child: RandomWords(repo),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          _navigateToAddScreen(context, repo);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _navigateToAddScreen(BuildContext context, InMemRepository repo) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => AddScreen()),
    );

    repo.addRecepie(result as Recepie);
    (context as Element).reassemble();
  }
}

class RandomWords extends StatefulWidget {
  InMemRepository repo;

  RandomWords(this.repo);

  @override
  _RandomWordsState createState() => _RandomWordsState(repo);
}

class _RandomWordsState extends State<RandomWords> {
  InMemRepository repo;
  List<Recepie> _suggestions;

  _RandomWordsState(this.repo) {
    _suggestions = repo.getRecepies();
  }

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: _buildSuggestions(),
    );
  }

  Widget _buildRow(Recepie pair) {
    return ListTile(

      title: Text(
        pair.title,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          size: 20.0,
          color: Colors.brown[900],
        ),
        onPressed: () {
          setState(() {
            // set up the buttons
            Widget cancelButton = FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            );
            Widget continueButton = FlatButton(
                child: Text("Continue"),
                onPressed: () {
                  setState(() {
                    _suggestions.remove(pair);
                    Navigator.pop(context);
                  });}
            );
            // set up the AlertDialog
            AlertDialog alert = AlertDialog(
              title: Text("You sure"),
              content: Text("Are you sure you want to delete?"),
              actions: [
                cancelButton,
                continueButton,
              ],
            );
            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          });
        },
      ),
      onTap: () {
        setState(() {
         _pushRecepie(pair, repo);
        });


      },
    );
  }

  Future<void> _pushRecepie(Recepie pair,InMemRepository repo) async {

    final result = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => RecepieAssetScreen(pair,repo),
      ),
      );

    var recepie = result as Recepie;
    repo.editRecepie(recepie);
    (context as Element).reassemble();

  }

  Widget _buildSuggestions() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once per suggested
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemCount: _suggestions.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 50,
          color: Colors.yellow[200],
          child: _buildRow(_suggestions[index]),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
