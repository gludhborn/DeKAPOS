import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:id/modify/kategoriModify.dart';
import 'package:id/view/menuView.dart';

class kategoriCard extends StatelessWidget {

  final kategoriModel getKategori;
  final String tenanId;
  final int jml;

  const kategoriCard({this.getKategori, this.tenanId, this.jml});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => kategoriModify(
              id: getKategori.idKategori,
              keterangan: getKategori.keterangan,
              tenanId: tenanId,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Card(
          elevation: 5,
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      getKategori.keterangan.toString(),
                      style: TextStyle(
                          backgroundColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Divider(height: 15, color: Colors.white),
                    ),
                    Text(
                      jml.toString() + " item",
                      style: TextStyle(
                          backgroundColor: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.white,
                          fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
