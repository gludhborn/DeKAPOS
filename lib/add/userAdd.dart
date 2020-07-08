import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/model/userModel.dart';
import 'package:id/view/menuView.dart';
import 'package:random_string/random_string.dart';

class userAdd extends StatefulWidget {
  const userAdd({Key key, this.tenanId});

  @override
  _userAddState createState() => _userAddState();

  final String tenanId;
}

class _userAddState extends State<userAdd> {

  String idUser, email, noHp, password, status, tenanId, username;

  bool ada;

  List _status = ["pimpinan","admin","kasir","barista","chef"];

  TextEditingController idUserController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController noHpController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController tenanIdController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  void _dialog(String title, String body, String action){
    showDialog<Null>(
        context: context,
        barrierDismissible: true, // user must tap button!
        child: new AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
          title:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title),
              Divider(color: Colors.blue,)
            ],
          ),
          content: Container(
            child: Text(body),
          ),
          actions: <Widget>[
            MaterialButton(
              minWidth:100,
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(action),
              color: Theme.of(context).primaryColor,
            ),
          ],
        )
    );
  }

  void _pengecekan(){
    Firestore.instance.collection('user').getDocuments().then((docs) {
      ada = false;
      for (int i = 0; i < docs.documents.length; i++){
        if(username == docs.documents[i]['username']){
          ada = true;
        }
      }

      if(ada == true){
        //muncul pop up
        _dialog("USERNAME", "Username anda telah digunakan\nGunakan Username yang lain", "Coba Lagi");
      } else {
        //mendaftarkan user
        _addData();
        showDialog<Null>(
            context: context,
            barrierDismissible: true, // user must tap button!
            child: new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              title:  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("SELAMAT")
                ],
              ),
              content: Container(
                  child: RichText(
                    text: TextSpan(
                        text: 'user ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: username,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                              text: ' berhasil di daftarkan ke tenan anda\nsebagai ',
                              style: TextStyle(
                                  color: Colors.black)
                          ),
                          TextSpan(
                              text: status,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                          ),
                          TextSpan(
                              text: ' dengan password ',
                              style: TextStyle(
                                  color: Colors.black)
                          ),
                          TextSpan(
                              text: password,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)
                          ),
                        ]
                    ),
                  )
              ),
              actions: <Widget>[
                MaterialButton(
                  minWidth:100,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
        );
      }
    });
  }

  void _addData() async{

    String id;
    String x;

//    tambah data ke user
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('user');
      await reference.add({
        "email"     : "",
        "noHp"      : "",
        "password"  : password,
        "status"    : status,
        "tenanId"   : widget.tenanId,
        "username"  : username
      });
      final String jobIdd= await reference.id;
    });
    //ini adalah perubahan

    //tambah data ke tenan
    await Firestore.instance.collection('tenan').document(widget.tenanId).collection("user")
        .document(id)
        .setData({
      "email"     : "",
      "noHp"      : "",
      "status"    : status,
      "username"  : username
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah User"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: <Widget>[
          SizedBox(
            height:25,
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.person),
              labelText: "Username",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Status"),
              SizedBox(width: 20),
              DropdownButton(
                hint: Text("pilih status"),
                value: status,
                items: _status.map((value) {
                  return DropdownMenuItem(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value){
                  setState(() {
                    status = value;
                  });
                },
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Theme.of(context).primaryColor),
            child: FlatButton(
              child: Text(
                "Tambah",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                password = randomAlphaNumeric(5);
                username = usernameController.text;
                _pengecekan();
              },
            ),
          )
        ],
      ),
    );
  }
}
