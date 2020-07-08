import 'package:flutter/material.dart';
import 'package:id/view/daftarView.dart';
import 'package:id/view/loginView.dart';
import 'package:id/view/menuView.dart';

void main(){
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme : ThemeData(
            canvasColor: Colors.white
        ),
        debugShowCheckedModeBanner: false,
        title: "Catatan Ku",
        home: loginView(),
        routes: <String, WidgetBuilder> {
          '/login' : (BuildContext context) => loginView(),
//          '/catatanku' : (BuildContext context) => MyTask(),
          '/daftar' : (BuildContext context) => daftarView(),
        }
    );
  }
}
