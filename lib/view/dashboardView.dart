import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';

void main() async {
  final PrinterNetworkManager printerManager = PrinterNetworkManager();
  printerManager.selectPrinter('192.168.0.123', port: 9100);

  final PosPrintResult res =
  await printerManager.printTicket(await testTicket());
  print('Print result: ${res.msg}');
}

Future<Ticket> testTicket() async {
  final Ticket ticket = Ticket(PaperSize.mm80);

  ticket.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: PosStyles(codeTable: PosCodeTable.westEur));
  ticket.text('Special 2: blåbærgrød',
      styles: PosStyles(codeTable: PosCodeTable.westEur));

  ticket.text('Bold text', styles: PosStyles(bold: true));
  ticket.text('Reverse text', styles: PosStyles(reverse: true));
  ticket.text('Underlined text',
      styles: PosStyles(underline: true), linesAfter: 1);
  ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
  ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
  ticket.text('Align right',
      styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  ticket.row([
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col6',
      width: 6,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
  ]);

  ticket.text('Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  // Print image
  // final ByteData data = await rootBundle.load('assets/logo.png');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final Image image = decodeImage(bytes);
  // ticket.image(image);
  // Print image using alternative commands
  // ticket.imageRaster(image);
  // ticket.imageRaster(image, imageFn: PosImageFn.graphics);

  // Print barcode
  final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
  ticket.barcode(Barcode.upcA(barData));

  // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
  // ticket.text(
  //   'hello ! 中文字 # world @ éphémère &',
  //   styles: PosStyles(codeTable: PosCodeTable.westEur),
  //   containsChinese: true,
  // );

  ticket.feed(2);

  ticket.cut();
  return ticket;
}

class dashboardView extends StatefulWidget {

  dashboardView({Key key, this.tenanId}) : super(key: key);

  @override
  _dashboardViewState createState() => _dashboardViewState();

  final String tenanId;
}

class _dashboardViewState extends State<dashboardView> {

  bool animate;

  List dataJSON;
  List tersusun;
  var linesalesdata;

  List<charts.Series<PendapatanHarian, int>> _seriesLineData;

  String nama, jumlah;
  String jml = "";

  String tanggal = "30042020";//DateFormat('ddMMyyy').format(DateTime.now()).toString();
  DateTime _dateTime = DateTime.now();

  //Pendapatan Harian
  _getDataPendapatanHarian(String tanggal) {
    List x = [];

    Firestore.instance.collection('tenan').document(widget.tenanId).collection(
        'transaksi').document(tanggal).collection('transaksi').orderBy(
        "jam", descending: false).getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((g) =>
      {
        x.add({
          'id': ('${g.data['jam']}').substring(0, 2).toString(),
          'total': '${g.data['totalTransaksi']}'
        }),
      });
      setState(() {
        _penyusunanDataPendaptanHarian();
      });
    });

    dataJSON = x;
    return x;
  }

  _penyusunanDataPendaptanHarian() {
    List z = [];
    bool sama;

    for (var n = 0; n < 24; n++) {
      String m;
      if (n < 10) {
        m = "0" + n.toString();
      } else {
        m = n.toString();
      }
      z.add({
        'id': m.toString(),
        'jam': m.toString() + ':00',
        'total': '0'
      });
    }

    for (var x = 1; x <= dataJSON.length - 1; x++) {
      sama = false;

      for (var y = 0; y <= z.length - 1; y++) {
        if (dataJSON[x]['id'] == z[y]['id']) {
          sama = true;

          //tambahTotal
          z[y]['total'] =
              (int.parse(z[y]['total']) + int.parse(dataJSON[x]['total']))
                  .toString();
        }
      }
    }

    tersusun = z;

    _seriesLineData = List<charts.Series<PendapatanHarian, int>>();
    _grafikDataPendapatanHarian();
    return z;
  }


  _grafikDataPendapatanHarian() {

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (PendapatanHarian x, _) => x.jam,
        measureFn: (PendapatanHarian x, _) => x.total,
      ),
    );
    setState(() {});
  }

  _getData() {
    List x = [];

    Firestore.instance.collection('tenan').document(widget.tenanId).collection(
        'transaksi').getDocuments().then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) =>
      {
        Firestore.instance.collection('tenan').document(widget.tenanId)
            .collection('transaksi').document(f.documentID).collection(
            'transaksi').getDocuments()
            .then((QuerySnapshot snapshot) {
          snapshot.documents.forEach((g) =>
          {
            Firestore.instance.collection('tenan').document(widget.tenanId)
                .collection('transaksi').document(f.documentID).collection(
                'transaksi').document(g.documentID).collection(
                'detailTransaksi').getDocuments()
                .then((QuerySnapshot snapshot) {
              snapshot.documents.forEach((h) =>
              {
                x.add({
                  'id': h.documentID,
                  'jumlah': '${h.data['jumlah']}',
                  'total': '${h.data['total']}'
                }),
              });
              setState(() {
                _penyusunan();
              });
            }),
          });
        }),
      });
    });

    dataJSON = x;
    return x;
  }

  _penyusunan() {
    print("penyusunan");

    List z = [];
    bool sama;

    z.add({
      'id': dataJSON[0]['id'],
      'jumlah': dataJSON[0]['jumlah'],
      'total': dataJSON[0]['total']
    });

    for (var x = 1; x <= dataJSON.length - 1; x++) {
      sama = false;

      for (var y = 0; y <= z.length - 1; y++) {
        if (dataJSON[x]['id'] == z[y]['id']) {
          sama = true;

          //tambahJumlah
          z[y]['jumlah'] =
              (int.parse(z[y]['jumlah']) + int.parse(dataJSON[x]['jumlah']))
                  .toString();

          //tambahTotal
          z[y]['total'] =
              (int.parse(z[y]['total']) + int.parse(dataJSON[x]['total']))
                  .toString();
        }
      }

      if (sama == false) {
        z.add({
          "id": dataJSON[x]['id'],
          "jumlah": dataJSON[x]['jumlah'],
          "total": dataJSON[x]['total']
        });
      }
    }

    tersusun = z;

    _getNamaMenu();
    return z;
  }

  _getNamaMenu() {
    print("getNamaMenu");

    for (var x = 0; x <= tersusun.length - 1; x++) {
      Firestore.instance.collection('tenan').document(widget.tenanId)
          .collection('item').document(tersusun[x]['id']).get().then((docs) {
        setState(() {
          tersusun[x]["id"] = docs["namaMakanan"];
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    dataJSON = [];
    tersusun = [];
    getSports(){};
    _seriesLineData = List<charts.Series<PendapatanHarian, int>>();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _getDataPendapatanHarian(tanggal));
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> x(){
      return [
        FlSpot(0, double.parse(tersusun[0]['total'])),
        FlSpot(1, double.parse(tersusun[1]['total'])),
        FlSpot(2, double.parse(tersusun[2]['total'])),
        FlSpot(3, double.parse(tersusun[3]['total'])),
        FlSpot(4, double.parse(tersusun[4]['total'])),
        FlSpot(5, double.parse(tersusun[5]['total'])),
        FlSpot(6, double.parse(tersusun[6]['total'])),
        FlSpot(7, double.parse(tersusun[7]['total'])),
        FlSpot(8, double.parse(tersusun[8]['total'])),
        FlSpot(9, double.parse(tersusun[9]['total'])),
        FlSpot(10, double.parse(tersusun[10]['total'])),
        FlSpot(11, double.parse(tersusun[11]['total'])),
        FlSpot(12, double.parse(tersusun[12]['total'])),
        FlSpot(13, double.parse(tersusun[13]['total'])),
        FlSpot(14, double.parse(tersusun[14]['total'])),
        FlSpot(15, double.parse(tersusun[15]['total'])),
        FlSpot(16, double.parse(tersusun[16]['total'])),
        FlSpot(17, double.parse(tersusun[17]['total'])),
        FlSpot(18, double.parse(tersusun[18]['total'])),
        FlSpot(19, double.parse(tersusun[19]['total'])),
        FlSpot(20, double.parse(tersusun[20]['total'])),
        FlSpot(21, double.parse(tersusun[21]['total'])),
        FlSpot(22, double.parse(tersusun[22]['total'])),
        FlSpot(23, double.parse(tersusun[23]['total'])),
      ];
    };

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Dashboard"),
              GestureDetector(
                  child: Container(
                    color: Theme
                        .of(context)
                        .primaryColor,
                    child: Text("Tanggal : " + tanggal.substring(0, 2) + " - " +
                        tanggal.substring(2, 4) + " - " +
                        tanggal.substring(4, 8),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,
                          fontSize: 25),),
                  ),
                  onTap: () {
                    showDatePicker(
                        context: context,
                        initialDate: _dateTime == null
                            ? DateTime.now()
                            : _dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100)
                    ).then((date) {
                      setState(() {
                        _dateTime = date;
                        tanggal = DateFormat('ddMMyyy')
                            .format(_dateTime)
                            .toString();
                      });
                    });
                  }
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 30),
          child: ListView(
            children: <Widget>[

              GestureDetector(
                onTap: testTicket,
                child: Text("Cetak Data"),
              ),

              Text("Pendapatan Per-Hari"),

              LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                          spots: x(),
                          isCurved: true,
                          belowBarData: BarAreaData(show: false),
                          colors: [Colors.blue],
                          barWidth: 3,
                          dotData: FlDotData(dotSize: 5)
                      ),
                    ],
                  )
              ),

              DataTable(
                columns: [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Jam')),
                  DataColumn(label: Text('Total')),
                ],
                rows: tersusun // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                  ((element) =>
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(element["id"])),
                          DataCell(Text(element["jam"])),
                          DataCell(Text(element["total"])),
                        ],
                      )),
                ).toList(),
              )
            ],
          ),
        )
    );
  }
}

class PendapatanHarian {
  int jam;
  int total;

  PendapatanHarian(this.jam, this.total);
}