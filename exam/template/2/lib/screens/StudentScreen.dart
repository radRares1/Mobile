import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttertemplate/config/ConfigManager.dart';
import 'package:myfluttertemplate/db/DbRepo.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/entities/ObjectInterface.dart';
import 'package:myfluttertemplate/repos/Repo.dart';
import 'package:myfluttertemplate/screens/AddScreen.dart';
import 'package:myfluttertemplate/screens/BookDetailScreen.dart';
import 'package:myfluttertemplate/server/ServerRepo.dart';
import 'package:myfluttertemplate/service/Service.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentScreen extends StatefulWidget {
  StudentScreen({Key key, this.title, this.list}) : super(key: key);
  final String title;
  final List<ObjectInterface> list;

  @override
  StudentState createState() => StudentState(list);
}

class StudentState extends State<StudentScreen> {
  ProgressDialog pr;
  static String url = 'http://192.168.1.5:2019';
  static DbRepo db = ConfigManager.getDbFromJsonConfig();
  ServerRepo server =
  ServerRepo(db, BookObject.emptyConstructor(), url);
  static Repo repository = Repo(db);
  Service service = Service(repository);

  List<BookObject> _list = <BookObject>[];
  bool isConnected;

  StudentState(this._list) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Your Books"),
          actions: <Widget>[
            IconButton(
              icon: Icon(CupertinoIcons.add),
              onPressed: () {
                addBook();
              },
            ),
            IconButton(
              icon: Icon(CupertinoIcons.refresh),
              onPressed: () {
                sync();
              },
            )
          ],
        ),
        body: //_buildSuggestions()
      ListView.builder(
        itemCount: _list.length,
        itemBuilder: (BuildContext context, int index) =>
            ListTile(
              title: Text("name: " +
                  _list[index].name.toString() +
                  "\n" +
                  "level: " +
                  _list[index].level.toString()+
                  "status: " +
                  _list[index].status.toString()
              ),
            ),
      )
    );
  }

  void addBook() async {
    String name = await getStringValuesSF();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddScreen(name)))
        .then((value) async {
      var id = await service.size();
      var request = value as BookObject;
      request.id = id * -1;
      bool isActive = await server.isActive();
      if (isActive) {
        server.insert(request);
        server.synchronize();
      } else {
        print("Adding book to db " + request.toString());
        service.addObject(request);
      }
      _list.add(request);
      (context as Element).reassemble();
    });
  }

  void sync() async {
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.show();
    server.synchronize();
  }

  // Widget _buildSuggestions() {
  //   return FutureBuilder(
  //     builder: (context, recepieSnap) {
  //       if (recepieSnap.connectionState == ConnectionState.none &&
  //           recepieSnap.hasData == null) {
  //         return Container();
  //       }
  //       return ListView.separated(
  //         padding: const EdgeInsets.all(16),
  //         itemCount: _list.length,
  //         itemBuilder: (BuildContext context, int index) {
  //           return Container(
  //             height: 50,
  //             color: Colors.yellow[200],
  //             child: _buildRow(_list[index]),
  //           );
  //         },
  //         separatorBuilder: (BuildContext context, int index) =>
  //         const Divider(),
  //       );
  //     },
  //     future: server.getItems(),
  //   );
  // }
  //
  // Widget _buildRow(BookObject book) {
  //   return ListTile(
  //     title: Text("title: " +
  //         book.title.toString() +
  //         "\n" +
  //         "status: " +
  //         book.status +
  //         "\n" +
  //         "student: " +
  //         book.student +
  //         "\n" +
  //         "pages: " +
  //         book.pages.toString() +
  //         "\n" +
  //         "count: " +
  //         book.usedCount.toString()
  //
  //     ),
  //     trailing: IconButton(
  //       icon: Icon(
  //         Icons.delete,
  //         size: 20.0,
  //         color: Colors.brown[900],
  //       ),
  //       onPressed: () {
  //         setState(() {
  //
  //           onPressedObject(book);
  //
  //         }
  //         );
  //       },
  //     ),
  //     onTap: () {
  //       _navigateToDetailScreen(book);
  //     },
  //   );
  // }

  void _navigateToDetailScreen(BookObject book) async  {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookDetailScreen(book)),
    );
  }

  void onPressedObject(BookObject book) async{

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );


    AlertDialog alert2 = AlertDialog(
      title: Text("Whoops"),
      content: Text("You can't delete while offline?"),
      actions: [
        cancelButton
      ],
    );

    // set up the buttons

    Widget continueButton = FlatButton(
        child: Text("Continue"),
        onPressed: () {
          setState(() {
            _list.remove(book);
            print("delete");
            (context as Element).reassemble();
            server.delete(book.id.toString());

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
    if(await checkConnected()){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert2;
        },
      );
    }
  }

  Future<bool> checkConnected() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else{
      return false;
    }
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('name');
    return stringValue;
  }


}