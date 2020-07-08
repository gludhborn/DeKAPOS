import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:random_string/random_string.dart';


class userDetailView extends StatefulWidget {
  const userDetailView({Key key, this.tenanId, this.email, this.noHp, this.status, this.username});

  @override
  _userDetailViewState createState() => _userDetailViewState();

  final String tenanId, email, noHp, status, username;
}

List<kategoriModel> listKategori;

class _userDetailViewState extends State<userDetailView> {

  String idUser, password;

  TextEditingController idItemController = new TextEditingController();
  TextEditingController namaMakananController = new TextEditingController();
  TextEditingController kategoriController = new TextEditingController();
  TextEditingController hargaController = new TextEditingController();
  TextEditingController biayaController = new TextEditingController();

  TextStyle style = TextStyle(
    fontSize: 25,
  );

  void resetPassword(String password){
//    Firestore.instance.collection('user').document(widget.tenanId).collection('user')
//        .document(widget.idItem)
//        .updateData({
//      "namaMakanan" : namaMakanan,
//      "kategori" : kategori,
//      "harga" : harga,
//      "biaya" : biaya
//    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Detail User"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Table(
                  border: new TableBorder(
                      horizontalInside: new BorderSide(color: Colors.grey[200], width: 0.5)
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    new TableRow(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text("Username", style: style),
                          ),
                          new Text(widget.username, style: style),
                        ]
                    ),
                    new TableRow(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text("Email", style: style),
                          ),
                          new Text(widget.email, style: style),
                        ]
                    ),
                    new TableRow(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text("No Hp", style: style),
                          ),
                          new Text(widget.noHp, style: style),
                        ]
                    ),
                    new TableRow(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text("Status", style: style),
                          ),
                          new Text(widget.status, style: style),
                        ]
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  height:50,
                  width: double.infinity,
                  child: RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    textColor: Colors.white,
                    color:Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    onPressed: (){
                      password = randomAlphaNumeric(5);
                      resetPassword(password);
                      showDialog<Null>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          child: new AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                            title:  Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("SELAMAT")
                              ],
                            ),
                            content: Container(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'password user ',
                                      style: TextStyle(color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: widget.username,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)
                                        ),
                                        TextSpan(
                                            text: ' berhasil di reset\nsilahkan login menggunakan ',
                                            style: TextStyle(
                                                color: Colors.black)
                                        ),
                                        TextSpan(
                                            text: password,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)
                                        ),
                                      ]
                                  ),
                                )
                            ),
                            actions: <Widget>[
                              MaterialButton(
                                minWidth:100,
                                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(12)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          )
                      );
                    },
                    child: Text("Reset Password", style: TextStyle(fontSize: 18.0)),
                  ),
                )
              ],
            )
          ),
        ],
      )
    );
  }
}
