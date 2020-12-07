import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recepie_flutter/main.dart';
import 'package:recepie_flutter/repos/InMemRepository.dart';

import 'Recepie.dart';

class EditScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController typeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController descController = TextEditingController();

  final Recepie recepie;
  InMemRepository repo;

  EditScreen(@required this.recepie, this.repo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Edit Recepie"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
              controller: titleNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: recepie.title,
              ),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
              controller: typeNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: recepie.type,
              ),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
              controller: ingredientsController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: recepie.ingredientsToString(),
              ),
            ),
            TextFormField(
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40),
              controller: descController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: recepie.description,
              ),
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FlatButton(
                height: 50,
                minWidth: 100,
                color: Colors.purple,
                onPressed: () {
                  var title = "";
                  var type = "";
                  var ingredients = List<String>();
                  var desc = "";
                  if (!titleNameController.text.isEmpty) {
                    title = titleNameController.text;
                  } else
                    title = this.recepie.title;

                  if (!typeNameController.text.isEmpty) {
                    type = typeNameController.text;
                  } else
                    type = this.recepie.type;

                  if (!ingredientsController.text.isEmpty) {
                    ingredients = ingredientsController.text.split(",");
                  } else
                    ingredients = this.recepie.ingredients;

                  if (!descController.text.isEmpty) {
                    desc = this.descController.text;
                  } else
                    desc = this.recepie.description;

                  var newRecepie = new Recepie(
                      this.recepie.id, title, type, ingredients, desc);

                  Navigator.pop(context,newRecepie);

                },
                child: Text(
                  'Edit',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
