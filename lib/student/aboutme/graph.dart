import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  List<charts.Series<ChartData, String>> _seriesData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    // Replace "HighCoins" and "Participation" with your actual collection names
    FirebaseFirestore.instance
        .collection('HighCoins')
        .snapshots()
        .listen((signupSnapshot) {
      FirebaseFirestore.instance
          .collection('Participation')
          .snapshots()
          .listen((participationSnapshot) {
        int signupCount = signupSnapshot.docs.length;
        int participationCount = participationSnapshot.docs.length;

        setState(() {
          _seriesData = [
            charts.Series<ChartData, String>(
              id: 'Documents Count',
              domainFn: (ChartData data, _) => data.collection,
              measureFn: (ChartData data, _) => data.count,
              data: [
                ChartData('100 Coins Reached Students', signupCount),
                ChartData('Participated Students', participationCount),
              ],
            ),
          ];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participation Chart'),
      ),
     body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: charts.BarChart(
                _seriesData,
                animate: true,
                animationDuration: Duration(milliseconds: 500),
                behaviors: [
                  charts.ChartTitle('Students', behaviorPosition: charts.BehaviorPosition.bottom),
                  charts.ChartTitle('Participated Students', behaviorPosition: charts.BehaviorPosition.start),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChartData {
  final String collection;
  final int count;

  ChartData(this.collection, this.count);
}