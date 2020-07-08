import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/service/references.dart';
import 'package:id/view/menuView.dart';

class loginView extends StatefulWidget {
  @override
  _loginViewState createState() => _loginViewState();
}

PreferenceUtil appData = new PreferenceUtil();

class _loginViewState extends State<loginView> {

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final Firestore _database = Firestore.instance;
  String username, password;

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
  _getLogin(){
    Firestore.instance.collection('user').where('username', isEqualTo: username).where('password', isEqualTo: password).getDocuments().then((docs){
      if(docs.documents.length>=1){
        setState(() {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => menuView(
                  userId: docs.documents[0].documentID,
                  nama: docs.documents[0]['namaUser'],
                  username: docs.documents[0]['username'],
                  password: docs.documents[0]['password'],
                  tenanId: docs.documents[0]['tenanId'],
                  status: docs.documents[0]['status'],
                  jmlTenan: 1,
                ),
              ));
        });
      } else {
        _dialog("GAGAL", "Username dan Password tidak cocok", "KETIK ULANG");
      }
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: WaveClipper1(),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40,
                      ),
                      Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "DEKA POS",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                      ),
                    ],
                  ),
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).primaryColor]
                      )
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextField(
                    controller: usernameController,
                    onChanged: (String value){},
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                        hintText: "Username",
                        prefixIcon: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 13)
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: TextField(
                    controller: passwordController,
                    cursorColor: Theme.of(context).primaryColor,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: Icon(
                            Icons.lock,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 13)
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  child:RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      username = usernameController.text;
                      password = passwordController.text;
                      _getLogin();
                    },
                    color:Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("MASUK".toUpperCase(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20,),
          Center(
            child:  GestureDetector(
              onTap: (){

              },
              child: Text("Lupa Passsword ?",
                style: TextStyle(
                    color:Theme.of(context).primaryColor,
                    fontSize: 12 ,
                    fontWeight: FontWeight.w700)),
            ),
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Belum Punya Akun ? ",
                style: TextStyle(
                    color:Colors.black,
                    fontSize: 12 ,
                    fontWeight: FontWeight.normal
                )
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/daftar');
                },
                child: Text("DAFTAR",
                    style: TextStyle(
                        color:Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        decoration: TextDecoration.underline)
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class WaveClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height - 50);

    var firstEndPoint = Offset(size.width * 0.6, size.height - 29 - 50);
    var firstControlPoint = Offset(size.width * .25, size.height - 60 - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 60);
    var secondControlPoint = Offset(size.width * 0.84, size.height - 50);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

@override
bool shouldReclip(CustomClipper<Path> oldClipper) {
  return false;
}