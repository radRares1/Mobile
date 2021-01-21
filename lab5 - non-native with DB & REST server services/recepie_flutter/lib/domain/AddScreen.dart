import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Recepie.dart';

class AddScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController typeNameController = TextEditingController();
  TextEditingController ingredientsController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("New Recepie"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              style: TextStyle(fontSize: 25),
              controller: titleNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: 'Enter the title',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the title';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              controller: typeNameController,
              decoration: InputDecoration(
                hintText: 'Enter the type',
                filled: true,
                fillColor: Colors.yellow[200],
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the type';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              controller: ingredientsController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow[200],
                hintText: 'Enter the ingredients',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the ingredients';
                }
                return null;
              },
            ),
            TextFormField(
              style: TextStyle(fontSize: 25),
              controller: descController,
              decoration: InputDecoration(
                hintText: 'Enter the description',
                filled: true,
                fillColor: Colors.yellow[200],
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter the description';
                }
                return null;
              },
            ),
            Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FlatButton(
                height: 50,
                minWidth: 100,
                color: Colors.purple,
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState.validate()) {
                    var ingredients = ingredientsController.text.split(",");
                    var recepie = new Recepie.withoutId(
                        titleNameController.text,
                        typeNameController.text,
                        ingredients,
                        descController.text);
                    Navigator.pop(context, recepie);
                  }
                },
                child: Text('Submit', style: TextStyle(fontSize: 40)),
              ),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
