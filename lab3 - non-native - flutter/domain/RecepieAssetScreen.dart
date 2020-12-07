import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepie_flutter/repos/InMemRepository.dart';

import 'EditScreen.dart';
import 'Recepie.dart';

class RecepieAssetScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  Recepie recepie;
  final TextStyle _biggerFont = const TextStyle(fontSize: 50);
  InMemRepository repo;

  // In the constructor, require a Todo.
  RecepieAssetScreen(@required this.recepie,this.repo);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(recepie.title),
      ),
      body: Column(
        children: [
          SizedBox(height: 50,child:Card(color:Colors.yellow)),
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.yellow[200],
            child: Text(
              "Type: " + recepie.type,
              style: _biggerFont,
              textAlign: TextAlign.left,
            ),
          ),
          Spacer(flex: 1),
          Container(
            alignment: Alignment.centerLeft,
            color: Colors.yellow[200],
            child: Text(
              "Ingredients: " + recepie.ingredientsToString(),
              style: _biggerFont,
              textAlign: TextAlign.left,
            ),
          ),
          Spacer(flex: 1),
          Container(
            alignment: Alignment.centerLeft,
            height: 50,
            color: Colors.yellow[200],
            child: Text(
              "Desc: " + recepie.description,
              style: _biggerFont,
              textAlign: TextAlign.left,
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {

            _navigateToEditScreen(context, recepie);

        },
        child: Icon(Icons.edit),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, Recepie recepie) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => EditScreen(recepie,repo)),
    );


    recepie = result as Recepie;
    //repo.editRecepie(recepie);

    Navigator.pop(context,recepie);
  }
}
