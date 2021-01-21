import 'package:flutter/material.dart';
import 'package:recepie_flutter/domain/Recepie.dart';
import 'package:recepie_flutter/domain/RecepieAssetScreen.dart';
import 'package:recepie_flutter/domain/AddScreen.dart';
import 'package:recepie_flutter/repos/DBRepo.dart';
import 'package:recepie_flutter/repos/InMemRepository.dart';
import 'package:recepie_flutter/repos/ServerRepo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //InMemRepository repo = new InMemRepository();
  DBRepo repo = DBRepo.dbInstance;
  ServerRepo server = ServerRepo();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Welcome to Flutter',
        home: Scaffold(body: HomeScreen(repo, server)));
    //new Scaffold(body: ListScreen(repo)));
  }
}

class HomeScreen extends StatelessWidget {
  //InMemRepository repo;
  DBRepo repo;
  ServerRepo server;

  HomeScreen(this.repo, this.server) {
    repo.addInitData();
    server.sync();
  }

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
                style: TextStyle(
                    fontSize: 50,
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
              child: Text("See recepies",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.push(
                  context,
                  // Create the SelectionScreen in the next step.
                  MaterialPageRoute(
                      builder: (context) => ListScreen(repo, server)),
                );
              },
            ),
            Spacer(flex: 1)
          ],
        ));
  }
}

class ListScreen extends StatelessWidget {
  //InMemRepository repo;
  DBRepo repo;
  ServerRepo server;

  ListScreen(this.repo, this.server);

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
        child: RandomWords(repo, server),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          _navigateToAddScreen(context, repo, server);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _navigateToAddScreen(
      BuildContext context, DBRepo repo, ServerRepo server) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => AddScreen()),
    );
    if (await server.isActive()) {
      server.insert(result as Recepie);
    } else {
      repo.addRecepie(result as Recepie);
    }
    (context as Element).reassemble();
  }
}

class RandomWords extends StatefulWidget {
  //InMemRepository repo;
  DBRepo repo;
  ServerRepo server;

  RandomWords(this.repo, this.server);

  @override
  _RandomWordsState createState() => _RandomWordsState(repo, server);
}

class _RandomWordsState extends State<RandomWords> {
  //InMemRepository repo;
  DBRepo repo;
  List<Recepie> _recepies;
  int length;
  ServerRepo server;
  bool isServerActive;

  bool checkServerActive() {
    this.server.isActive().then((active) {
      isServerActive = active;
    });
    return isServerActive;
  }

  void getRecepiesFromFuture() async {
    //var result = ;
    if (isServerActive) {
      _recepies = await server.getAll();
    } else {
      _recepies = await repo.getRecepies();
    }
  }

  _RandomWordsState(this.repo, this.server);

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    getRecepiesFromFuture();
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: _buildSuggestions(),
    );
  }

  //the future builder waits for the result to be completed and only
  //then it calles the build
  //if it's not ready it returns an empty container
  Widget _buildSuggestions() {
    return FutureBuilder(
      builder: (context, recepieSnap) {
        if (recepieSnap.connectionState == ConnectionState.none &&
            recepieSnap.hasData == null) {
          return Container();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _recepies.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.yellow[200],
              child: _buildRow(_recepies[index]),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
      future: isServerActive ? server.getAll() : repo.getRecepies(),
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
                    _recepies.remove(pair);
                    if (isServerActive) {
                      server.delete(pair.id);
                    } else {
                      repo.deleteRecepie(pair.id);
                    }
                    Navigator.pop(context);
                  });
                });
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
          _pushRecepie(pair, repo, server);
        });
      },
    );
  }

  Future<void> _pushRecepie(Recepie pair, DBRepo, ServerRepo server) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecepieAssetScreen(pair, repo),
      ),
    );

    var recepie = result as Recepie;
    if (isServerActive) {
      server.update(recepie);
    } else {
      repo.editRecepie(recepie);
    }
    (context as Element).reassemble();
  }
}
