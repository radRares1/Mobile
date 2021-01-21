import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttertemplate/config/ConfigManager.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/repos/Repo.dart';
import 'package:myfluttertemplate/service/Service.dart';


class AddScreen extends StatefulWidget {


  final String studentName;
  const AddScreen(this.studentName);

  @override
  State createState() {
    return AddScreenState(studentName);
  }
}

class AddScreenState extends State<AddScreen> {
  String studentName;
  CupertinoTextField titleText;
  CupertinoTextField statusText;
  CupertinoTextField pagesText;
  CupertinoTextField countText;
  CupertinoTextField levelText;
  TextEditingController titleController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController pagesController = TextEditingController();
  TextEditingController countController = TextEditingController();


  RaisedButton addEditButton;
  Service service =
  Service(Repo(ConfigManager.getDbFromJsonConfig()));
  BuildContext context;
  State parent;

  AddScreenState(this.studentName) {
    titleText = CupertinoTextField(
      controller: titleController,
    );

    statusText = CupertinoTextField(
      controller: statusController,
    );

    pagesText = CupertinoTextField(
      controller: pagesController,
    );

    countText = CupertinoTextField(
      controller: countController,
    );

    levelText = CupertinoTextField(
      controller: levelController,
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
                levelText,
                SizedBox(height: 40),
                statusText,
                SizedBox(height: 40),
                pagesText,
                SizedBox(height: 40),
                countText,
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
        titleController.text,levelController.text,statusController.text,pagesController.text,countController.text);
    Navigator.pop(context, object);
  }
}
