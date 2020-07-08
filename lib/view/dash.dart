import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:id/model/mejaModel.dart';

class HomePage extends StatefulWidget {
  final Widget child;

  final String tenanId;

  HomePage({Key key, this.child, this.tenanId}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<charts.Series<Sales, int>> _seriesLineData;
  List<mejaModel> mejaList;

  _generateData() {
    var linesalesdata = [
      new Sales(0,1000),
      new Sales(1,1100),
      new Sales(2,1200),
      new Sales(3,1300),
      new Sales(4,1400),
      new Sales(5,1500),
      new Sales(6,1600),
      new Sales(7,1700),
      new Sales(8,1800),
      new Sales(9,1900),
      new Sales(10,11000),
      new Sales(11,11100),
      new Sales(12,11200),
      new Sales(13,11300),
      new Sales(14,11400),
      new Sales(15,11500),
      new Sales(16,11600),
      new Sales(17,11700),
      new Sales(18,11800),
      new Sales(19,11900),
      new Sales(20,12000),
      new Sales(21,12100),
      new Sales(22,12200),
      new Sales(23,12300),
    ];

    var linesalesdata1 = [
      new Sales(1, 46),
      new Sales(2, 45),
      new Sales(3, 50),
      new Sales(4, 51),
      new Sales(5, 40),
      new Sales(6, 51),
      new Sales(7, 40),
      new Sales(8, 46),
      new Sales(9, 45),
      new Sales(10, 50),
      new Sales(11, 51),
      new Sales(12, 40),
      new Sales(13, 51),
      new Sales(14, 40),
    ];

    var linesalesdata2 = [
      new Sales(1, 24),
      new Sales(2, 25),
      new Sales(3, 40),
      new Sales(4, 45),
      new Sales(5, 70),
      new Sales(6, 0),
      new Sales(7, 70),
      new Sales(8, 24),
      new Sales(9, 25),
      new Sales(10, 40),
      new Sales(11, 45),
      new Sales(12, 70),
      new Sales(13, 0),
      new Sales(14, 70),
    ];

    var linesalesdata3 = [
      new Sales(1, 23),
      new Sales(2, 14),
      new Sales(3, 13),
      new Sales(4, 41),
      new Sales(5, 81),
      new Sales(6, 36),
      new Sales(7, 15),
      new Sales(8, 23),
      new Sales(9, 14),
      new Sales(10, 13),
      new Sales(11, 41),
      new Sales(12, 81),
      new Sales(13, 36),
      new Sales(14, 15),
    ];

    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff990099)),
        id: 'Air Pollution',
        data: linesalesdata,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xff109618)),
        id: 'Air Pollution',
        data: linesalesdata1,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Color(0xffff9900)),
        id: 'Air Pollution',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
    _seriesLineData.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.black),
        id: 'Air s',
        data: linesalesdata3,
        domainFn: (Sales sales, _) => sales.yearval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();

    }

  List<DataColumn> columns;
  List<DataRow> rows;
  DataColumn clmn;

  final List<Map<String, String>> listOfColumns = [
    {"Name": "AAAAAA", "Number": "1", "State": "Yes"},
    {"Name": "BBBBBB", "Number": "2", "State": "no"},
    {"Name": "CCCCCC", "Number": "3", "State": "Yes"}
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
            'Sales for the first 5 years',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
          Container(
            height: 500,
            width: 500,
            child: charts.LineChart(_seriesLineData,
                primaryMeasureAxis: new charts.NumericAxisSpec(
                    tickProviderSpec: new charts.StaticNumericTickProviderSpec(
                      // Create the ticks to be used the domain axis.
                      <charts.TickSpec<num>>[
                        new charts.TickSpec(10, label: '10'),
                        new charts.TickSpec(20, label: '20'),
                        new charts.TickSpec(30, label: '30'),
                        new charts.TickSpec(40, label: '40'),
                        new charts.TickSpec(80, label: '80'),
                      ],
                    )),

                disjointMeasureAxes:
                new LinkedHashMap<String, charts.NumericAxisSpec>.from({
                  'axis 1': new charts.NumericAxisSpec(),
                  'axis 2': new charts.NumericAxisSpec(),
                  'axis 3': new charts.NumericAxisSpec(),
                  'axis 4': new charts.NumericAxisSpec(),
                })
            ),
          ),
          DataTable(
            columns: [
              DataColumn(label: Text('Meja')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Status')),
            ],
            rows: listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                .map(
              ((element) => DataRow(
                cells: <DataCell>[
                  DataCell(Text(element["Name"])), //Extracting from Map element the value
                  DataCell(Text(element["Number"])),
                  DataCell(Text(element["State"])),
                ],
              )),
            ).toList(),
          )
        ],
      ),
    );
  }
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}