import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/service/references.dart';

class daftarView extends StatefulWidget {
  @override
  _daftarViewState createState() => _daftarViewState();
}

PreferenceUtil appData = new PreferenceUtil();

class _daftarViewState extends State<daftarView> {

  String alamatUser, email, namaUser, noHpUser, username, password;
  bool ada;

  TextEditingController alamatUserController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController namaUserController = new TextEditingController();
  TextEditingController noHpController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();

  _pengecekan(){
    Firestore.instance.collection('user').getDocuments().then((docs) {
      ada = false;
      for (int i = 0; i < docs.documents.length; i++){
        if(username == docs.documents[i]['username']){
          ada = true;
        }
      }

      if(ada == true){
        print("Username telah digunakan");
        //muncul pop up
        _dialog("USERNAME", "Username anda telah digunakan\nGunakan Username yang lain", "COBA LAGI");
      } else {
        //mendaftarkan user
        _addData();
        showDialog<Null>(
            context: context,
            barrierDismissible: true, // user must tap button!
            child: new AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              title:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("SELAMAT"),
                  Divider(color: Colors.blue,)
                ],
              ),
              content: Container(
                child: Text("Akun anda telah terdaftar\nSilahkan Login"),
              ),
              actions: <Widget>[
                MaterialButton(
                  minWidth:100,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text("LOGIN"),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            )
        );
      }
    });
  }

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

  void _addData() async{
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('user');
      await reference.add({
        "alamatUser":alamatUser,
        "email":email,
        "namaUser":namaUser,
        "noHp":noHpUser,
        "password":password,
        "username":username
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Daftar"),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: namaUserController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.perm_contact_calendar),
              labelText: "Nama Pengguna",
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.person),
              labelText: "Username",
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.lock),
              labelText: "Password",
            ),
            obscureText: true,
          ),
          SizedBox(height: 10,),
          TextField(
              controller: password2Controller,
              decoration: InputDecoration(
                fillColor: Theme.of(context).canvasColor,
                filled: true,
                icon: Icon(Icons.lock),
                labelText: "Password",
              ),
            obscureText: true,
          ),
          TextField(
            controller: noHpController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.phone),
              labelText: "No Hp",
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.mail),
              labelText: "Email",
            ),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: alamatUserController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.home),
              labelText: "Alamat Pengguna",
            ),
            maxLines: 4,
          ),
          SizedBox(height: 30,),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Theme.of(context).primaryColor),
            child: FlatButton(
              child: Text(
                "Daftar",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                namaUser = namaUserController.text;
                username = usernameController.text;
                password = passwordController.text;
                noHpUser = noHpController.text;
                email = emailController.text;
                alamatUser = alamatUserController.text;
                if(password == password2Controller.text){
                  _pengecekan();
                } else {
                  _dialog("PASSWORD", "Password yang anda masukkan berbeda", "KETIK ULANG");
                }
              },
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}