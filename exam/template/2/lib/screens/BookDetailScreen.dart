import 'package:flutter/material.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';

import 'EditScreen.dart';

class BookDetailScreen extends StatelessWidget {
  BookObject book;
  final TextStyle _biggerFont = const TextStyle(fontSize: 50);

  BookDetailScreen(@required this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Book Detail"),
        ),
        body: Column(
          children: [
            SizedBox(height: 50, child: Card(color: Colors.white)),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.yellow[200],
              child: Text(
                "Name: " + book.name,
                style: _biggerFont,
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(flex: 1),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.yellow[200],
              child: Text(
                "Level: " + book.level,
                style: _biggerFont,
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(flex: 1),
        Container(
          alignment: Alignment.centerLeft,
          color: Colors.yellow[200],
            child:
            Text(
              "Id: " + book.id.toString(),
              style: _biggerFont,
              textAlign: TextAlign.left,
            )),
            Spacer(flex: 1),
            Container(
                alignment: Alignment.centerLeft,
                color: Colors.yellow[200],
                child:
                Text(
                  "Status: " + book.status,
                  style: _biggerFont,
                  textAlign: TextAlign.left,
                )),
            Spacer(flex: 1),
            Container(
                alignment: Alignment.centerLeft,
                color: Colors.yellow[200],
                child:
                Text(
                  "From: " + book.from.toString(),
                  style: _biggerFont,
                  textAlign: TextAlign.left,
                )),
            Spacer(flex: 1),
            Container(
                alignment: Alignment.centerLeft,
                color: Colors.yellow[200],
                child:
                Text(
                  "To: " + book.to.toString(),
                  style: _biggerFont,
                  textAlign: TextAlign.left,
                )),
            Spacer(flex: 1),

          ],
        ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {

          _navigateToEditScreen(context, book);

        },
        child: Icon(Icons.edit),
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, BookObject recepie) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => EditScreen(recepie)),
    );


    recepie = result as BookObject;
    //repo.editRecepie(recepie);

    Navigator.pop(context,recepie);
  }
}
