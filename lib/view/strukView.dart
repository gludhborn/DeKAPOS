import 'dart:developer';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:id/model/transaksiListModel.dart';
import 'package:id/model/transaksiModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class strukView extends StatefulWidget {
  const strukView({Key key, this.tenanId}) : super(key: key);

  @override
  _strukViewState createState() => _strukViewState();

  final String tenanId;
}

String idStruk, document;
List<Transaksi> transaksi;
List<TransaksiList> transaksiList;
final oCcy = new NumberFormat("#,##0", "en_US");

class _strukViewState extends State<strukView> {

  int total = 0;
  double tinggi = 0;
  String jam = "", namaPembeli = "";
    String tanggal = DateFormat('ddMMyyy').format(DateTime.now()).toString();
  List dataJSON;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    transaksi = [];
    idStruk = "";
    document = "";
    transaksi = [];
    transaksiList = [];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Struk"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //list view
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.33,
            height: MediaQuery.of(context).size.height,
            child:Column(
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(15),
                  width: double.infinity,
                  child: GestureDetector(
                      child:Container(
                        color: Theme.of(context).primaryColor,
                        child: Text(tanggal.substring(0,2) + " - " + tanggal.substring(2,4) + " - " + tanggal.substring(4,8),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontSize: 25),),
                      ),
                      onTap: (){
                        showDatePicker(
                            context: context,
                            initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100)
                        ).then((date) {
                          setState(() {
                            _dateTime = date;
                            tanggal = DateFormat('ddMMyyy').format(_dateTime).toString();
                          });
                        });
                      }
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(tanggal).collection("transaksi").orderBy("jam", descending: false).snapshots(),
                    builder: (BuildContext ctx2, AsyncSnapshot<QuerySnapshot> snap2) {
                      List<Transaksi> x;
                      if (!snap2.hasData) return Text('sedang mencari...');
                      x = snap2.data.documents.map((doc) => Transaksi.fromMap(doc.data, doc.documentID)).toList();
                      transaksi.addAll(x);
                      return
                        ListView.builder(

                            itemCount: x.length,
                            itemBuilder: (bldctx, indx) =>
                                Container(
                                  child:GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        idStruk = snap2.data.documents[indx].documentID;
                                        document = tanggal;
                                        total = int.parse(x[indx].total);
                                        jam  = x[indx].jam;
                                        namaPembeli = x[indx].pembeli;
                                      });
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "#" + x[indx].id,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 20,
                                                      color: Colors.grey,
                                                      fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Rp. " + oCcy.format(int.parse(x[indx].total)),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      height: 2,
                                                      fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  x[indx].jam,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      height: 2,
                                                      fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  x.length.toString(),
//                                                              snapshot.data.documents[index].documentID,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 20,
                                                      color: Colors.grey,
                                                      fontStyle: FontStyle.italic),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            Divider(height: 1, color: Colors.grey,)
                                          ],
                                        )
                                    ),
                                  ),
                                )
                        );
                    },
                  ),
                )
              ],
            )
          ),

          //cash view
          Container(
            color: Color.fromRGBO(239, 239, 239, 1),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.67,
            height: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(left: 100, right: 100),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5, right: 50, left: 50),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 30,),
                      Text("Total Pembayaran",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54
                        ),
                        textAlign: TextAlign.center,),
                      Text("Rp. " + oCcy.format(total).toString(),
                        style: TextStyle(
                            fontSize: 50,
                            height: 1.5
                        ),
                        textAlign: TextAlign.center,),
                      SizedBox(height: 30),
                      Divider(height: 2,color: Colors.black38,),
                      Row(
                        children: <Widget>[
                          Text("Kasir : " ,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black,
                                height: 2,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          Text("",
                            style: TextStyle(
                                fontSize: 20,
                                height: 2,
                                color: Colors.black,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row (
                        children: <Widget>[
                          Text("Pembeli : ",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black,
                                height: 2,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                          Text(namaPembeli,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                height: 2,
                                fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Divider(height: 2,color: Colors.black38,),
                      SizedBox(height: 10,),
                      StreamBuilder(
                        stream: Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(document).collection("transaksi").document(idStruk).collection("detailTransaksi").snapshots(),
                        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> snap) {
                          if (!snap.hasData) return Text('sedang mencari...');
                          return Container(height: snap.data.documents.length * 65.0 + 10 *  snap.data.documents.length,
                            child: StreamBuilder(
                              stream: Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(document).collection("transaksi").document(idStruk).collection("detailTransaksi").snapshots(),
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) return Text('sedang mencari...');
                                transaksiList = snapshot.data.documents
                                    .map((doc) => TransaksiList.fromMap(doc.data, doc.documentID))
                                    .toList();
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: transaksiList.length,
                                  itemBuilder: (buildContext, index) =>
                                      Container(
                                        child: Align(
                                            child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          transaksiList[index].namaMakanan,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                              height: 2,
                                                              fontStyle: FontStyle.italic),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Text(
                                                          "Rp. " + oCcy.format(int.parse(transaksiList[index].total)),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20,
                                                              color: Colors.black,
                                                              height: 2,
                                                              fontStyle: FontStyle.italic),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        Text(
                                                          transaksiList[index].jumlah,
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20,
                                                              color: Colors.grey,
                                                              fontStyle: FontStyle.italic),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        Text(
                                                          " x "  + oCcy.format(int.parse(transaksiList[index].harga_jual)),
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 20,
                                                              color: Colors.grey,
                                                              fontStyle: FontStyle.italic),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,)
                                                  ],
                                                )
                                            )
                                        ),
                                      ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      Divider(height: 3,color: Colors.black,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(idStruk),
                          ),
                          Expanded(
                              child: Text(jam,
                            textAlign: TextAlign.right,),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}