import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/add/itemAdd.dart';
import 'package:id/card/itemCard.dart';
import 'package:id/model/itemModel.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:id/view/menuView.dart';

class itemView extends StatefulWidget {
  const itemView({Key key, this.tenanId}) : super(key: key);

  @override
  _itemViewState createState() => _itemViewState();

  final String tenanId;
}

List<kategoriModel> listKategori;

class _itemViewState extends State<itemView> {

  List<itemModel> itemList;
  String kategori = "Semua";
  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').orderBy('namaMakanan').snapshots();

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
                        .width * .7,
                    child: GestureDetector(
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
                                    kategori = "Semua";
                                    _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('item').orderBy('namaMakanan').snapshots();
                                  });}
                            ),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (String value) async {
                            kategori = "semua";
                            if (value != '') {
                              _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').where('namaMakanan', isGreaterThanOrEqualTo: value).where('namaMakanan', isLessThan: value +'z').orderBy('namaMakanan').snapshots();
                              setState(() {});
                              print(value);
                            } else{
                              _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').orderBy('namaMakanan').snapshots();
                              setState(() {});
                              print("kosong");
                            }
                          }
                      ),
                    )
                ),
                Container(
                    child: GestureDetector(
                      onTap: (){
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          child: new AlertDialog(
                            contentPadding: const EdgeInsets.all(10.0),
                            title: new Text(
                              'Kategori',
                              style:
                              new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            content: new Container(
                              // Specify some width
                              width: MediaQuery.of(context).size.width * .7,
                              child:StreamBuilder(
                                stream : Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori').orderBy("keterangan").snapshots(),
                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) return Text('sedang mencari...');
                                  listKategori = snapshot.data.documents
                                      .map((doc) => kategoriModel.fromMap(doc.data, doc.documentID))
                                      .toList();
                                  return GridView.builder(
                                    itemCount: listKategori.length,
                                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5),
                                    itemBuilder: (buildContext, index) =>
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              kategori = listKategori[index].keterangan;
                                              _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('item').where('kategori',isEqualTo: kategori).orderBy('namaMakanan').snapshots();
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Card(
                                              elevation: 5,
                                              child: Container(
                                                color: Theme.of(context).primaryColor,
                                                child: Align(
                                                    child: Container(
                                                      child: Text(
                                                        listKategori[index].keterangan,
                                                        style: TextStyle(
                                                            backgroundColor: Theme.of(context).primaryColor,
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 20,
                                                            color: Colors.white,
                                                            fontStyle: FontStyle.italic),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                            actions: <Widget>[
                              new IconButton(
                                  splashColor: Colors.red,
                                  icon: new Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          ),
                        );
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.category),
                          Text(" " + kategori,
                            style: TextStyle(
                              color:Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,),
                          IconButton(
                              splashColor: Colors.white,
                              icon: new Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  kategori = "Semua";
                                  _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('item').orderBy('namaMakanan').snapshots();
                                });
                              })
                        ],
                      ),
                    )
                )
              ],
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return Text('sedang mencari...');
            itemList = snapshot.data.documents
                .map((doc) =>  itemModel.fromMap(doc.data, doc.documentID))
                .toList();
            return GridView.builder(
              itemCount: itemList.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (buildContext, index) => itemCard(
                  getItem: itemList[index],
                  tenanId: widget.tenanId),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => itemAdd(tenanId: widget.tenanId)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
