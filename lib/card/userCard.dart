import 'package:flutter/material.dart';
import 'package:id/model/userModel.dart';
import 'package:id/view/userDetailView.dart';

class userCard extends StatelessWidget {

  final userModel getuser;
  final String tenanId;

  const userCard({this.getuser, this.tenanId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => userDetailView(
              tenanId: tenanId,
              email: getuser.email,
              noHp: getuser.noHp,
              status: getuser.status,
              username: getuser.username,
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
                      getuser.username.toString(),
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
                      getuser.status.toString(),
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
