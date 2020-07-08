import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class kategoriModify extends StatefulWidget {

  @override
  _kategoriModifyState createState() => _kategoriModifyState();

  final String tenanId, id, keterangan;

  kategoriModify({Key key, this.tenanId, this.id, this.keterangan});
}

class _kategoriModifyState extends State<kategoriModify> {

  String id, keterangan = '';

  TextEditingController keteranganController = new TextEditingController();

  void _update(){
    try {
      Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori')
          .document(widget.id)
          .updateData({'keterangan': keterangan});
    } catch (e) {}
  }

  void _deleteData() {
    try{
      Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori')
          .document(widget.id)
          .delete();
    } catch(e) {}
  }

  @override
  Widget build(BuildContext context) {
    keteranganController.text = widget.keterangan;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Kategori"),
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
              icon: Icon(Icons.category),
              labelText: "Kategori",
              hintText: widget.keterangan
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
