import 'package:flutter/material.dart';
import 'package:id/model/tenanModel.dart';


class tenanCard extends StatelessWidget {
  final UserTenan getUserTenan;
  final String tenanId, userId;
  final index;

  tenanCard({this.getUserTenan, this.index, this.tenanId, this.userId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(20.0),
            color: Colors.blue[200],
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(20.0),
                      color: Colors.white,)
                ),
              ),
              SizedBox(height: 20,),
              Text(getUserTenan.namaTenan,
                style: TextStyle(
                  color:Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,)
            ],
          ),
        ),
      ),
    );
  }
}

