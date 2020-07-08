import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:intl/intl.dart';
import 'package:id/service/currencyFormat.dart';

class itemAdd extends StatefulWidget {
  const itemAdd({Key key, this.tenanId});

  @override
  _itemAddState createState() => _itemAddState();

  final String tenanId;
}

class _itemAddState extends State<itemAdd> {

  String idItem, namaMakanan, harga, biaya;
  String kategori = "";

  TextEditingController idItemController = new TextEditingController();
  TextEditingController namaMakananController = new TextEditingController();
  TextEditingController kategoriController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController biayaController = new TextEditingController();

  void _addData() async{
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('tenan').document(widget.tenanId).collection('item');
      await reference.add({
        "namaMakanan" : namaMakanan,
        "kategori" : kategori,
        "harga" : harga,
        "biaya" : biaya
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    List<kategoriModel> listKategori;


    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Item"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30),
        children: <Widget>[
          SizedBox(
            height:25,
          ),
          TextField(
            controller: namaMakananController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.fastfood),
              labelText: "Nama Makanan",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text("Kategori : " + kategori,
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
                              stream: Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori').orderBy("keterangan").snapshots(),
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
                                                          color: Colors.black87,
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
                    child: Text("Pilih Kategori",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black45,
                        )),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: hargaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.attach_money),
              labelText: "Harga Jual",
              prefixText: "Rp. ",
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: biayaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              fillColor: Theme.of(context).canvasColor,
              filled: true,
              icon: Icon(Icons.money_off),
              labelText: "Biaya",
              prefixText: "Rp. ",
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
                "Tambah",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              onPressed: () {
                biaya = biayaController.text;
                namaMakanan = namaMakananController.text;
                harga = hargaController.text;
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
