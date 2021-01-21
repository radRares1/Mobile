import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfluttertemplate/config/ConfigManager.dart';
import 'package:myfluttertemplate/db/DbRepo.dart';
import 'package:myfluttertemplate/entities/BookObject.dart';
import 'package:myfluttertemplate/repos/Repo.dart';
import 'package:myfluttertemplate/screens/AuthScreen.dart';
import 'package:myfluttertemplate/screens/BookScreen.dart';
import 'package:myfluttertemplate/screens/StudentScreen.dart';
import 'package:myfluttertemplate/server/ServerRepo.dart';
import 'package:myfluttertemplate/service/Service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';

class Home extends StatefulWidget {
  final IOWebSocketChannel channel =
      IOWebSocketChannel.connect("ws://192.168.1.5:2019");

  @override
  State<StatefulWidget> createState() {
    return _HomeState(channel: channel);
  }
}

class _HomeState extends State<Home> {
  final WebSocketChannel channel;

  final List<Widget> _children = [
    AuthScreen(title: "Authenticate"),
    BookScreen(title: "", list: allBooks),
    StudentScreen(title: "", list: studentBooks)
  ];

  String name = "";
  static String url = 'http://192.168.1.5:2019';
  static DbRepo db = ConfigManager.getDbFromJsonConfig();
  ServerRepo server = ServerRepo(db, BookObject.emptyConstructor(), url);
  static Repo repository = Repo(db);
  Service service = Service(repository);
  bool isActive = true;
  bool isConnected;
  int _currentIndex = 0;
  static List<BookObject> allBooks = <BookObject>[];
  static List<BookObject> studentBooks = <BookObject>[];

  _HomeState({this.channel}) {
    channel.stream.listen((data) {
      var d = jsonDecode(data);
      Fluttertoast.showToast(
          msg: d['title'] + " was added!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void _readBooksFromServer() async {

    String localName = await getStringValuesSF();
    if (name == "") {
      if (localName != "") {
        name = localName;
        print("NAME" + this.name);
        var it = await server.getStudentBooks(localName);
        it.forEach((element) async {
          if (!studentBooks.contains(element)) {
            studentBooks.add(element);
          }
        });
      }
    } else if (name != "") {
      studentBooks.clear();
      name = localName;
      print("NAME" + this.name);
      var it = await server.getStudentBooks(localName);
      it.forEach((element) async {
        if (!studentBooks.contains(element)) {
          studentBooks.add(element);
        }
      });
    }


    allBooks.clear();
    var itms = await server.getItems();
    itms.forEach((element) {
      allBooks.add(element);
    });
  }

  void _readBooksFromDB() async {
    allBooks.clear();
    var items = await service.getObjects();
    print("LOCAL DB: " + items.toString());
    items.forEach((element) {
      allBooks.add(element);
    });
  }

  void onScreenTapped(int index) async {
    bool isActive = await server.isActive();
    bool isConnected = await this.checkConnected();
    await print("server is " + isActive.toString());
    if (index == 1) {
      if (isConnected) {
        //_readBooksFromServer();
      } else {
        print("get from db");
        showAlertDialog("Offline", "Data is local, please connect to the internet and press the refresh button");
        _readBooksFromDB();

      }
    } else if (index == 2) {
      if (isConnected) {
        //_readBooksFromServer();
      } else {
        print("get from db");
        showAlertDialog("Offline", "Data is local, please connect to the internet and press the refresh button");
        _readBooksFromDB();

      }
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Exam',
          style: new TextStyle(color: Colors.white70, fontSize: 14.0),
        ),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onScreenTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_open, color: Colors.grey),
            title: Text("First",
                style: new TextStyle(
                    color: const Color(0xFF06244e), fontSize: 14.0)),
            backgroundColor: Colors.white70,
          ),
          new BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_open, color: Colors.grey),
            backgroundColor: Colors.white70,
            title: Text("Second Screen",
                style: new TextStyle(
                    color: const Color(0xFF06244e), fontSize: 14.0)),
          ),
          new BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.folder_open, color: Colors.grey),
            backgroundColor: Colors.white70,
            title: Text("Third Screen",
                style: new TextStyle(
                    color: const Color(0xFF06244e), fontSize: 14.0)),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("I was called");
    //_readFromDB();
    allBooks.clear();
    studentBooks.clear();
    _readBooksFromServer();
    print(allBooks);
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
