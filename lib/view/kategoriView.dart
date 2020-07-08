import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/add/kategoriAdd.dart';
import 'package:id/card/kategoriCard.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:id/view/menuView.dart';

class kategoriView extends StatefulWidget {
  const kategoriView({Key key, this.tenanId}) : super(key: key);

  @override
  _kategoriViewState createState() => _kategoriViewState();

  final String tenanId;
}

int jumlah;

_getJumlah(String keterangan){
  Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('kategori').where("keterangan", isEqualTo:keterangan).getDocuments().then((QuerySnapshot snapshot) {
    snapshot.documents.forEach((g) => {
      jumlah = g.data.length
    });
  });
}

class _kategoriViewState extends State<kategoriView> {

  List<kategoriModel> kategoriList;
  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('kategori').orderBy('keterangan').snapshots();

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
                                    _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori').orderBy('keterangan').snapshots();
                                  });}
                            ),
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          onChanged: (String value) async {
                            _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('kategori').where('keterangan', isGreaterThanOrEqualTo: value).where('keterangan', isLessThan: value +'z').orderBy('keterangan', descending: false).snapshots();
                            setState(() {});
                            print(value);
                          }
                      ),
                    )
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
            kategoriList = snapshot.data.documents
                .map((doc) =>  kategoriModel.fromMap(doc.data, doc.documentID))
                .toList();
            return GridView.builder(
                itemCount: kategoriList.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5),
                itemBuilder: (buildContext, index) =>
                    StreamBuilder(
                        stream: Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').where("kategori", isEqualTo: kategoriList[index].keterangan).snapshots(),
                        builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> spt) {
                          if (!snapshot.hasData) return Text('sedang mencari...');
                          kategoriList = snapshot.data.documents
                              .map((doc) => kategoriModel.fromMap(doc.data, doc.documentID))
                              .toList();
                          return kategoriCard(
                              jml: spt.data.documents.length,
                              getKategori: kategoriList[index],
                              tenanId: widget.tenanId);
                        }));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => kategoriAdd(tenanId: widget.tenanId)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
