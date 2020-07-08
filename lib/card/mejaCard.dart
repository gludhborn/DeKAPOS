import 'package:flutter/material.dart';
import 'package:id/model/mejaModel.dart';
import 'package:id/modify/mejaModify.dart';
  
class mejaCard extends StatelessWidget {

  final mejaModel getMeja;
  final String tenanId;

  const mejaCard({this.getMeja, this.tenanId});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => mejaModify(
              id: getMeja.idMeja,
              keterangan: getMeja.keterangan,
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
                child: Container(
                  child: Text(
                    getMeja.keterangan.toString(),
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
    );
  }
}
