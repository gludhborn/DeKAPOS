import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/add/userAdd.dart';
import 'package:id/model/userModel.dart';
import 'package:id/card/userCard.dart';
import 'package:id/view/menuView.dart';

class userView extends StatefulWidget {
  const userView({Key key, this.tenanId}) : super(key: key);

  @override
  _userViewState createState() => _userViewState();

  final String tenanId;
}

class _userViewState extends State<userView> {

  List<userModel> userList;
  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('user').orderBy('username').snapshots();

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
                                _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('user').orderBy('username').snapshots();
                              });}
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (String value) async {
                        _stream = Firestore.instance.collection('tenan').document(widget.tenanId).collection('user').where('username', isGreaterThanOrEqualTo: value).where('username', isLessThan: value +'z').orderBy('username', descending: false).snapshots();
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
            userList = snapshot.data.documents
                .map((doc) =>  userModel.fromMap(doc.data, doc.documentID))
                .toList();
            return GridView.builder(
              itemCount: userList.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5),
              itemBuilder: (buildContext, index) => userCard(
                  getuser: userList[index],
                  tenanId: widget.tenanId),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => userAdd(tenanId: widget.tenanId)));
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}