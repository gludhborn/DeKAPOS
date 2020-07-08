import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:id/model/ketegoriModel.dart';
import 'package:id/view/dashboardView.dart';
import 'package:id/view/strukView.dart';
import 'package:id/view/transaksiView.dart';
import 'package:id/view/itemView.dart';
import 'package:id/view/kategoriView.dart';
import 'package:id/view/mejaView.dart';
import 'package:id/view/tenanView.dart';
import 'package:id/view/userView.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class menuView extends StatefulWidget {

  final nama,username,password,tenanId, jmlTenan, userId;
  final String status;
  menuView({this.nama, this.username, this.password, this.tenanId, this.status, this.jmlTenan, this.userId});

  static String tenanDefault;

  @override
  State<StatefulWidget> createState() {
    return new menuViewState();
  }
}

List<kategoriModel> listKategori;

class menuViewState extends State<menuView> {

  AppBar appBar;
  int _selectedDrawerIndex = 1;
  String kategori = "Semua";

  Stream<QuerySnapshot> _stream = Firestore.instance.collection('tenan').document(menuView.tenanDefault).collection('item').orderBy('namaMakanan').snapshots();

  var drawerTenan = [
    new DrawerItem("Tenan", Icons.home),
    new DrawerItem("User", Icons.person),
    new DrawerItem("Pengaturan", Icons.settings),
    new DrawerItem("Keluar", Icons.exit_to_app)
  ];

  var drawerTenan1 = [
    new DrawerItem("Dashboard", Icons.dashboard),
    new DrawerItem("Kasir", Icons.shopping_basket),
    new DrawerItem("Struk", Icons.receipt),
    new DrawerItem("Kategori Menu", Icons.category),
    new DrawerItem("Menu", Icons.fastfood),
    new DrawerItem("Meja", Icons.table_chart),
    new DrawerItem("Tenan", Icons.home),
    new DrawerItem("User", Icons.person),
    new DrawerItem("Pengaturan", Icons.settings),
    new DrawerItem("Keluar", Icons.exit_to_app)
  ];
  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }


  @override
  Widget build(BuildContext context) {

    menuView.tenanDefault = widget.tenanId;

    MaterialApp(
        debugShowCheckedModeBanner: false
    );

    _getDrawerItemWidget(int pos) {
      if(widget.jmlTenan==1){
        switch (pos) {
          case 0:
            return new dashboardView(tenanId: widget.tenanId);
          case 1:
            return new transaksiView(tenanId: widget.tenanId);
          case 2:
            return new strukView(tenanId: widget.tenanId);
          case 3:
            return new kategoriView(tenanId: widget.tenanId);
          case 4:
            return new itemView(tenanId: widget.tenanId);
          case 5:
            return new mejaView(tenanId: widget.tenanId);
          case 6:
            return new tenanView(userId: widget.userId, userName: widget.username);
          case 7:
            return new userView(tenanId: widget.tenanId);
          case 8:
          case 9:
          default:
            new Text("Error");
        }
      } else {
        switch (pos) {
          case 0:
          case 1:
            return new tenanView(userId: widget.userId, userName: widget.username);
          case 2:
          case 3:
          default:
            return new Text("Error");
        }
      }
    }

    AppBar appBarMakanan = AppBar(
      title: Text("Deka-Pos"),
    );

    var drawerOptions = <Widget>[];
    var drawerItems;

    if(widget.status=="admin"){
      drawerItems = drawerTenan1;
    } else {
      drawerItems = drawerTenan;
    }

    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      drawer: new Drawer(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: new Column(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                    accountName: new Text(widget.status)),
                new Column(children: drawerOptions)
              ],
            ),
          )
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}

