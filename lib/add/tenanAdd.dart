import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class tenanAdd extends StatefulWidget {

  @override
  _tenanAddState createState() => _tenanAddState();

  final String id, userId, userName;

  tenanAdd({this.id, this.userId, this.userName});
}

class _tenanAddState extends State<tenanAdd> {

  String namaTenan, alamatTenan;

  TextEditingController namaTenanControlller = new TextEditingController();
  TextEditingController alamatTenanControlller = new TextEditingController();

  void _addData() async{
    //add tenan
    String tenanId;
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('tenan');
      await reference.add({
        "namaTenan" : "DeKADE Coffee",
        "alamatTenan" : "Jalan VORVO"
      }).then((docs){tenanId = docs.documentID;});
    });
    Timer(Duration(seconds: 3), () {
//      add tenan/user
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('tenan').document(tenanId).collection("user");
      await reference.add({
        "idUser" : widget.userId,
        "jabatan" : "admin",
        "namaUser" : widget.userName
      });
    }); 
//    add user/tenan
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('user').document(widget.userId).collection("tenan");
      await reference.add({
        "tenanId" : tenanId,
        "namaTenan" : namaTenan,
        "alamatTenan" : alamatTenan
      });
    });
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tambah Tenan"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          TextField(
            controller: namaTenanControlller,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.home),
              labelText: "Nama Tenan",
            ),
          ),
          TextField(
            controller: alamatTenanControlller,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.location_on),
              labelText: "Alamat Tenan",
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
                "Buat Tenan",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                namaTenan = namaTenanControlller.text;
                alamatTenan = alamatTenanControlller.text;
                _addData();
              },
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}