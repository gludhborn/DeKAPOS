import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/add/tenanAdd.dart';
import 'package:id/card/tenanCard.dart';
import 'package:id/model/tenanModel.dart';

class tenanView extends StatefulWidget {
  const tenanView({Key key, this.userId, this.userName}) : super(key: key);

  @override
  _tenanViewState createState() => _tenanViewState();
  final String userId, userName;
}

class _tenanViewState extends State<tenanView> {

  List<UserTenan> userTenan;

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.6,
              child: StreamBuilder(
                  stream: Firestore.instance.collection('user').document(widget.userId).collection("tenan").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return Text('sedang mencari...');
                    userTenan = snapshot.data.documents
                        .map((doc) => UserTenan.fromMap(doc.data, doc.documentID))
                        .toList();
                    if(userTenan.length<=0){
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20),
                            Text(
                              "Anda tidak terdaftar di tenan manapun",
                              style: TextStyle(fontSize: 20),),
                            SizedBox(height: 10),
                          ],
                        ),
                      );
                    } else {
                      return GridView.builder(
                          itemCount: userTenan.length,
                          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                          itemBuilder: (buildContext, index) => tenanCard(
                              getUserTenan: userTenan[index],
                      ));
                    }
                  }
              ),
            ),
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: GestureDetector(
                      onTap:(){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => tenanAdd(userId: widget.userId)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 200,
                        width: 200,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(20.0),
                          color: Colors.blue[200],
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 20,),
                            Icon(
                              Icons.add_circle_outline,
                              size: 100,
                              color: Colors.white,),
                            SizedBox(height: 10,),
                            Text(
                              "Buat Tenan",
                              style: TextStyle(
                                  color:Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.4,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 30,),
                        Text("Id untuk ditambakan ke Admin",
                          style: TextStyle(fontSize: 20),),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 100,
                          width: 700,
                          decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(20.0),
                            color: Colors.blue[200],
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 20,),
                              Text(widget.userId,
                                style: TextStyle(
                                  color:Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            )
          ],
        )
    );
  }
}

//void sementara(){

//}