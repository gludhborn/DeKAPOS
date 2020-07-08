import 'package:flutter/material.dart';
import 'package:id/model/itemModel.dart';
import 'package:id/modify/itemModify.dart';

class itemCard extends StatelessWidget {

  final itemModel getItem;
  final String tenanId;

  const itemCard({this.getItem, this.tenanId});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => itemModify(
              idItem: getItem.idItem,
              namaMakanan: getItem.namaMakanan,
              kategori: getItem.kategori,
              harga: getItem.harga,
              biaya: getItem.biaya,
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
                    getItem.namaMakanan.toString(),
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
