import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:id/model/itemModel.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:id/service/references.dart';
import 'package:id/view/menuView.dart';
import 'package:id/view/pembayaranView.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class transaksiView extends StatefulWidget {
  transaksiView({Key key, this.tenanId}) : super(key: key);

  @override
  _transaksiViewState createState() => _transaksiViewState();

  final String tenanId;
  static bool reset;
}

String bayar;
PreferenceUtil appData = new PreferenceUtil();
List<kategoriModel> listKategori;

class _transaksiViewState extends State<transaksiView> {

  List dataJSON;
  final oCcy = new NumberFormat("#,##0", "en_US");
  List<itemModel> items;
  bool ada;
  int urut;
  int Total =0;
  String kategori = "Semua";
  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').orderBy('namaMakanan').snapshots();

  TextEditingController pencarianController = new TextEditingController();

  void tambah(String id, String nama, String jumlah, String total, String harga) {

    ada=false;

    if (dataJSON.length <= 0) {
      baru(id, nama, jumlah, total, harga);
    } else {
      for (var i = 0; i <= dataJSON.length-1; i++) {
        if (id.toString() == dataJSON[i]['idMakanan'].toString()) {
          setState(() {
            dataJSON[i]['jumlah'] = (int.parse(dataJSON[i]['jumlah']) + 1).toString();
            dataJSON[i]['total'] = (int.parse(dataJSON[i]['total']) + int.parse(total)).toString();
          });
          ada=true;
        }
      }
      if(ada==false){
        baru(id, nama, jumlah, total, harga);
      }
    }

    Total = Total + int.parse(total);
  }

  void baru(String id, String nama, String jumlah, String total,String harga) {
    dataJSON.add({
      "idMakanan" : id,
      "namaMakanan": nama,
      "jumlah": jumlah,
      "total": total,
      "harga" : harga,
    });
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    dataJSON = [];
    bayar = " 0";
  }

  @override
  Widget build(BuildContext context) {

    if(transaksiView.reset == true){
      super.initState();
      dataJSON.clear();
      Total =0;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.66,
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
                          kategori = "Semua";
                          if (value != '') {
                            _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').where('namaMakanan', isGreaterThanOrEqualTo: value).where('namaMakanan', isLessThan: value +'z').orderBy('namaMakanan').snapshots();
                            setState(() {});
                          } else{
                            _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').orderBy('namaMakanan').snapshots();
                            setState(() {});
                          }
                        }
                    ),
                  )
              ),
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.33,
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
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //items view
          Container(
            color: Color.fromRGBO(239, 239, 239, 1),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.67,
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Text('sedang mencari...',
                  style: TextStyle(
                    color: Colors.black45,
                    backgroundColor: Color.fromRGBO(239, 239, 239, 1),
                  ),);
                items = snapshot.data.documents
                    .map((doc) => itemModel.fromMap(doc.data, doc.documentID))
                    .toList();
                return GridView.builder(
                  itemCount: items.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5),
                  itemBuilder: (buildContext, index) =>
                      GestureDetector(
                        onTap: () {
                          transaksiView.reset = false;

                          String id = items[index].idItem.toString();
                          String nama = items[index].namaMakanan.toString();
                          String jumlah = "1";
                          String total = (int.parse(items[index].harga)).toString();
                          String harga = items[index].harga.toString();

                          setState(() {
                            tambah(id, nama, jumlah, total, harga);
                          });

                          setState((){
                            bayar = (int.parse(bayar) + int.parse(total)).toString();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(0),
                          child: Card(
                            elevation: 5,
                            child: Container(
                              color: Theme.of(context).primaryColor,
                              child: Align(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    child: Text(
                                      items[index].namaMakanan,
                                      style: TextStyle(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 30,
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

          //list view
          Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.33,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataJSON == null ? 0 : dataJSON.length,
                      itemBuilder: (context, i) => GestureDetector(
                        onTap: (){
                          //...Klicked
                        },
                        child: Container(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: 8, right: 8,top: 10, bottom: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          dataJSON[i]['namaMakanan'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          " x " + dataJSON[i]['jumlah'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          oCcy.format(int.parse(dataJSON[i]['total'])),
//                                      dataJSON[i]['total'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        SizedBox(width: 10),
                                        GestureDetector(
                                          child: Icon(Icons.delete_outline),
                                          onTap: (){
                                            int ttl;
                                            if(dataJSON[i]['jumlah'] == "1"){
                                              ttl = int.parse(dataJSON[i]['total']);
                                              dataJSON.removeAt(i);
                                              setState(() {});
                                            } else{
                                              ttl = (int.parse(dataJSON[i]['total']) / int.parse(dataJSON[i]['jumlah'])).toInt();
                                              dataJSON[i]['total'] = (int.parse(dataJSON[i]['total']) - ttl).toString();
                                              setState(() {});
                                              dataJSON[i]['jumlah'] = (int.parse(dataJSON[i]['jumlah']) - 1).toString();
                                              setState(() {});
                                            }
                                            Total = Total - ttl;
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Total :", style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.left),
                                Text("Rp. " + oCcy.format(Total), style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.right),
                              ],
                            ),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              padding: const EdgeInsets.all(10.0),
                              textColor: Colors.white,
                              color:Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              onPressed: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) => pembayaranView(
                                      getDataJSON: dataJSON,
                                      getTotal: Total,
                                      tenanId: widget.tenanId,
                                    )));
                              },
                              child: Text("Bayar", style: TextStyle(fontSize: 18.0)),
//                              child: Text(transaksiView.data.toString(), style: TextStyle(fontSize: 18.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}