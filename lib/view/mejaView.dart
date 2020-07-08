import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/add/mejaAdd.dart';
import 'package:id/model/mejaModel.dart';
import 'package:id/card/mejaCard.dart';
import 'package:id/view/menuView.dart';

class mejaView extends StatefulWidget {
  const mejaView({Key key, this.tenanId}) : super(key: key);

  @override
  _mejaViewState createState() => _mejaViewState();

  final String tenanId;
}

class _mejaViewState extends State<mejaView> {

  List<mejaModel> mejaList;
  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('meja').orderBy('keterangan').snapshots();

  TextEditingController pencarianController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width-10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width *0.99,
                  child: TextField(
                      cursorColor: Theme.of(context).canvasColor,
                      controller: pencarianController,
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).primaryColor,
                        hintText: "Cari",
                        suffix: IconButton(
                            padding: EdgeInsets.only(top: 15),
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                pencarianController.clear();
                                _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja').orderBy('keterangan').snapshots();
                              });}
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (String value) async {
                        _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja').where('keterangan', isGreaterThanOrEqualTo: value).where('keterangan', isLessThan: value +'z').orderBy('keterangan', descending: false).snapshots();
                        setState(() {});
                        print(value);
                      }
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('sedang mencari...');
            mejaList = snapshot.data.documents
                .map((doc) =>  mejaModel.fromMap(doc.data, doc.documentID))
                .toList();
            return GridView.builder(
              itemCount: mejaList.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (buildContext, index) => mejaCard(
                  getMeja: mejaList[index],
                  tenanId: widget.tenanId),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => mejaAdd(tenanId: widget.tenanId)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}