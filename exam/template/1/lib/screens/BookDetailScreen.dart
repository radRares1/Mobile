import 'package:flutter/material.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';

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
                "Title: " + book.title,
                style: _biggerFont,
                textAlign: TextAlign.left,
              ),
            ),
            Spacer(flex: 1),
            Container(
              alignment: Alignment.centerLeft,
              color: Colors.yellow[200],
              child: Text(
                "Date: " + book.date,
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
          ],
        ));
  }
}
