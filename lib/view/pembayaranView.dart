import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:id/model/mejaModel.dart';
import 'package:id/view/transaksiView.dart';
import 'package:intl/intl.dart';

import '../service/references.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class pembayaranView extends StatefulWidget {
  const pembayaranView({Key key, this.getDataJSON, this.getTotal, this.tenanId}) : super(key: key);

  @override
  _pembayaranViewState createState() => _pembayaranViewState();

  final String tenanId;
  final List getDataJSON;
  final int getTotal;
}

String bayar;
List dataTask;
PreferenceUtil appData = new PreferenceUtil();
var oCcy = new NumberFormat("#,##0", "en_US");
List<mejaModel> meja;
String namaPembeli, totalTransaksi;

class _pembayaranViewState extends State<pembayaranView> {

  final oCcy = new NumberFormat("#,##0", "en_US");
  String nomorMeja = "0";
  String idMeja = "???";
  String noHp = "";

  TextEditingController namaPembeleiControlller = new TextEditingController();
  TextEditingController noHpControlller = new TextEditingController();

  void _pembayaran(){

    String jam = DateFormat('hh.mm').format(DateTime.now()).toString();
    String hari = DateFormat('ddMMyyy').format(DateTime.now()).toString();
    bool ada = false;

      //perHari
      Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').where('tanggal', isEqualTo: hari).getDocuments().then((QuerySnapshot snapshot) {
        snapshot.documents.forEach((f) => {
          //tambah Total
          ada = true,
          //menambahkan
          Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(hari.toString()).setData({
            "total" : (widget.getTotal + int.parse('${f.data['total']}')).toString(),
            "tanggal" : hari,
          })
        });

        if(ada==false){
          //buat baru
          Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(hari.toString()).setData({
            "tanggal" : hari,
            "total" : (widget.getTotal).toString(),
          });
        }
      });

      Firestore.instance.collection('tenan').document(widget.tenanId).collection('transaksi').document(hari.toString()).collection('transaksi').getDocuments().then((docs) {
      String noUrut = (docs.documents.length + 1).toString();

      Firestore.instance.runTransaction((Transaction transaction) async {

        //addData
        await Firestore.instance.collection('tenan').document(widget.tenanId)
            .collection('transaksi').document(hari.toString()).collection('transaksi')
            .document(noUrut)
            .setData({
          "jam": jam,
          "namaPembeli": namaPembeli,
          "totalTransaksi": widget.getTotal.toString(),
          //nomorMeja menjadi idMeja
          "idMeja": idMeja,
          "noHp": noHp
        });

        //addDetail
        for (var i = 0; i <= widget.getDataJSON.length - 1; i++) {
          await Firestore.instance.collection('tenan').document(widget.tenanId)
              .collection('transaksi').document(hari)
              .collection('transaksi').document(noUrut)
              .collection('detailTransaksi').document(widget.getDataJSON[i]["idMakanan"]).setData({
            "namaMakanan" : widget.getDataJSON[i]["namaMakanan"],
            "jumlah": widget.getDataJSON[i]["jumlah"],
            "total": widget.getDataJSON[i]["total"],
            "harga": widget.getDataJSON[i]["harga"]
          });

          if(i>=widget.getDataJSON.length-1){
            transaksiView.reset = true;
            Navigator.of(context).pop();
            setState(() {});
          }
        }
      });
    });

  }

  void _simpan() {
    String jam = DateFormat('hh.mm').format(DateTime.now()).toString();

    Firestore.instance.collection('tenan').document(widget.tenanId).collection('belumLunas').getDocuments().then((docs) {
      String noUrut = (docs.documents.length + 1).toString();
      print(noUrut);

      Firestore.instance.runTransaction((Transaction transaction) async {

        //addData
        await Firestore.instance.collection('tenan').document(widget.tenanId)
            .collection('belumLunas').document(noUrut)
            .setData({
          "jam": jam,
          "namaPembeli": namaPembeli,
          "totalTransaksi": widget.getTotal.toString(),
          "idMeja": idMeja,
          "noHp": noHp
        });

        //addDetail
        for (var i = 0; i <= widget.getDataJSON.length - 1; i++) {
          await Firestore.instance.collection('tenan').document(widget.tenanId)
              .collection('belumLunas').document(noUrut)
              .collection('detailTransaksi').document(widget.getDataJSON[i]["idMakanan"]).setData({
            //nama menjadi idBarang
            "namaMakanan" : widget.getDataJSON[i]["namaMakanan"],
            "jumlah": widget.getDataJSON[i]["jumlah"],
            "total": widget.getDataJSON[i]["total"],
            "harga": widget.getDataJSON[i]["harga"]
          });

          if(i>=widget.getDataJSON.length-1){
            transaksiView.reset = true;
            Navigator.of(context).pop();
            setState(() {});
          }
        }
      });
    });

  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  void initState() {
    bayar = " 0";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Pembayaran"),
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
              child:ListView.builder(
                itemCount: widget.getDataJSON == null ? 0 : widget.getDataJSON.length,
                itemBuilder: (context, i) => GestureDetector(
                  onTap: (){
                    //...Klicked
                  },
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.getDataJSON[i]['namaMakanan'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    " x " + widget.getDataJSON[i]['jumlah'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Colors.black54,
                                        fontStyle: FontStyle.italic),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                              Text(
                                oCcy.format(int.parse(widget.getDataJSON[i]['total'])),
//                                      widget.getDataJSON[i]['total'],
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontStyle: FontStyle.italic),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ),

          //cash view
          Container(
              color: Color.fromRGBO(239, 239, 239, 1),
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.67,
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 60),
                child: ListView(
                  children: <Widget>[
                    Text("Total Pembayaran",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),),
                    Text("Rp. " + oCcy.format(widget.getTotal).toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 40)),
                    SizedBox(height: 80,),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("Meja : " + nomorMeja,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18)),
                        ),
                        Expanded(
                          child: SizedBox(
                            height:50,
                            width: double.infinity,
                            child: RaisedButton(
                              textColor: Colors.white,
                              color:Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)
                              ),
                              onPressed: (){
                                showDialog<Null>(
                                  context: context,
                                  barrierDismissible: false, // user must tap button!
                                  child: new AlertDialog(
                                    contentPadding: const EdgeInsets.all(10.0),
                                    title: new Text(
                                      'Meja',
                                      style:
                                      new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                    ),
                                    content: new Container(
                                      // Specify some width
                                      width: MediaQuery.of(context).size.width * .7,
                                      child:StreamBuilder(
                                        stream: Firestore.instance.collection('tenan').document(widget.tenanId).collection('meja').orderBy("keterangan").snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                          if (!snapshot.hasData) return Text('sedang mencari...');
                                          meja = snapshot.data.documents
                                              .map((doc) => mejaModel.fromMap(doc.data, doc.documentID))
                                              .toList();
                                          return GridView.builder(
                                            itemCount: meja.length,
                                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 5),
                                            itemBuilder: (buildContext, index) =>
                                                GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      nomorMeja = meja[index].keterangan;
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
                                                                meja[index].keterangan,
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
                              child: Text("Pilih Meja",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black45,
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10,),
                    SizedBox(height: 10,),
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        controller: namaPembeleiControlller,
                        onChanged: (String value){},
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                            labelText: "Nama Pembeli",
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
                            EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextField(
                        controller: noHpControlller,
                        onChanged: (String value){},
                        cursorColor: Theme.of(context).primaryColor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "no Hp",
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.phone,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                      ),
                    ),
                    SizedBox(height: 40,),
                    SizedBox(
                      height:50,
                      width: double.infinity,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color:Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        onPressed: (){
                          namaPembeli = namaPembeleiControlller.text;
                          totalTransaksi = widget.getTotal.toString();
                          noHp = noHpControlller.text;
                          _pembayaran();
                        },
                        child: Text("Bayar", style: TextStyle(fontSize: 25.0)),
                      ),
                    ),
                    SizedBox(height: 10,),
                    SizedBox(
                      height:50,
                      width: double.infinity,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color:Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                        onPressed: (){
                          namaPembeli = namaPembeleiControlller.text;
                          totalTransaksi = widget.getTotal.toString();
                          noHp = noHpControlller.text;
                          _simpan();
                        },
                        child: Text("Simpan", style: TextStyle(fontSize: 25.0)),
                      ),
                    ),
                    SizedBox(height: 5,),
                  ],
                ),
              )
          ),
        ],
      ),
    );
  }
}
