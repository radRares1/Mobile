import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttertemplate/config/ConfigManager.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/repos/Repo.dart';
import 'package:myfluttertemplate/service/Service.dart';

class AddScreen extends StatefulWidget {


  const AddScreen();

  @override
  State createState() {
    return AddScreenState();
  }
}

class AddScreenState extends State<AddScreen> {
  CupertinoTextField titleText;
  TextEditingController titleController = TextEditingController();


  RaisedButton addEditButton;
  Service service =
  Service(Repo(ConfigManager.getDbFromJsonConfig()));
  BuildContext context;
  State parent;

  AddScreenState() {
    titleText = CupertinoTextField(
      controller: titleController,
    );

    addEditButton = RaisedButton(
      onPressed: addAnnouncement,
      child: Text('Add'),
    );
  }

  Widget _buildTiles() {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add a book"),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Book title"),
                SizedBox(height: 10),
                titleText,
                SizedBox(height: 40),
                addEditButton
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return _buildTiles();
  }

  addAnnouncement() {
    BookObject object = BookObject.withoutId(
        titleController.text,"date");
    Navigator.pop(context, object);
  }
}
