import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/view/strukView.dart';

class mejaAdd extends StatefulWidget {
  const mejaAdd({Key key, this.tenanId});

  @override
  _mejaAddState createState() => _mejaAddState();

  final String tenanId;
}

class _mejaAddState extends State<mejaAdd> {

  String keterangan = '';

  TextEditingController keteranganController = new TextEditingController();

  void _addData() async{
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja');
      await reference.add({
        "keterangan" : keterangan,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Meja"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: <Widget>[
          SizedBox(
            height:25,
          ),
          TextField(
            controller: keteranganController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.table_chart),
              labelText: "Meja",
            ),
          ),           SizedBox(
            height: 20,
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
                keterangan = keteranganController.text;
                _addData();
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
