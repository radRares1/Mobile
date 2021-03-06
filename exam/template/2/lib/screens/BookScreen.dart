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

class BookScreen extends StatefulWidget {
  BookScreen({Key key, this.title, this.list}) : super(key: key);
  final String title;
  final List<ObjectInterface> list;

  @override
  BookState createState() => BookState(list);
}

class BookState extends State<BookScreen> {
  ProgressDialog pr;
  static String url = 'http://192.168.1.5:2019';
  static DbRepo db = ConfigManager.getDbFromJsonConfig();
  ServerRepo server =
  ServerRepo(db, BookObject.emptyConstructor(), url);
  static Repo repository = Repo(db);
  Service service = Service(repository);

  List<BookObject> _list = <BookObject>[];
  bool isConnected;

  BookState(this._list) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Books"),
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
        body: _buildSuggestions()
        // ListView.builder(
        //   itemCount: _list.length,
        //   itemBuilder: (BuildContext context, int index) =>
        //       ListTile(
        //         title: Text("title: " +
        //             _list[index].title.toString() +
        //             "\n" +
        //             "date: " +
        //             _list[index].date.toString()
        //         ),
        //       ),
        // )
    );
  }

  void addBook() async {
    String name = await getStringValuesSF();

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddScreen(name)))
        .then((value) async {
      var id = _list.length;
      var request = value as BookObject;
      request.id = id * -1;
      print("id in addBook" + request.id.toString());
      print(request);
      bool isActive = await server.isActive();
      if (isActive) {
        server.insert(request);
        //server.synchronize();
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
    (context as Element).reassemble();
  }

  Widget _buildSuggestions() {
    return FutureBuilder(
      builder: (context, recepieSnap) {
        if (recepieSnap.connectionState == ConnectionState.none &&
            recepieSnap.hasData == null) {
          return Container();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _list.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              color: Colors.yellow[200],
              child: _buildRow(_list[index]),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
          const Divider(),
        );
      },
      future: server.getItems(),
    );
  }

  Widget _buildRow(BookObject book) {
    return ListTile(
      title: Text("title: " +
         book.name.toString() +
          "\n" +
          "level: " +
         book.level +
          "\n" +
          "status: " +
          book.status +
          "\n" +
          "from: " +
          book.from.toString() +
          "\n" +
          "to: " +
          book.to.toString()

      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          size: 20.0,
          color: Colors.brown[900],
        ),
        onPressed: () {
          setState(() {

            onPressedObject(book);

          }
          );
        },
      ),
      onTap: () {
          _navigateToDetailScreen(book);
      },
    );
  }

  void _navigateToDetailScreen(BookObject book) async  {

    if(await checkConnected()) {
      BookObject bookFromServer = await server.getItem(book.id.toString());
      print(bookFromServer.toString());
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookDetailScreen(bookFromServer)),
      );
      var emp = result as BookObject;
      await server.update(result as BookObject);
      if(emp.id!=null){
        _list.forEach((element) {if(element.id==emp.id)
          element = emp;} );
      }
      (context as Element).reassemble();
    }
    else{
      showAlertDialog("Offline", "Sorry u can't see the details offline");
    }
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

  void showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
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