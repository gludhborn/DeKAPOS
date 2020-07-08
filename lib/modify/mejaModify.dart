import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mejaModify extends StatefulWidget {

  @override
  _mejaModifyState createState() => _mejaModifyState();

  final String tenanId, id, keterangan;

  mejaModify({Key key, this.tenanId, this.id, this.keterangan});
}

class _mejaModifyState extends State<mejaModify> {

  String id, keterangan = '';

  TextEditingController keteranganController = new TextEditingController();

  void _update(){
    try {
      Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja')
          .document(widget.id)
          .updateData({'keterangan': keterangan});
    } catch (e) {}
  }

  void _deleteData() {
    try{
      Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja')
          .document(widget.id)
          .delete();
    } catch(e) {}
  }

  @override
  Widget build(BuildContext context) {

    keteranganController.text = widget.keterangan;

    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Meja"),
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
          ),
          SizedBox(
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
                "Ubah",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                keterangan = keteranganController.text;
                _update();
                Navigator.pop(context);
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Theme.of(context).errorColor),
            child: FlatButton(
              child: Text(
                "Hapus",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                keterangan = keteranganController.text;
                _deleteData();
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
