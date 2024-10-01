class TradeModel {
  List<Data>? data;

  TradeModel({this.data});

  TradeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? asset;
  String? last;
  String? bid;
  String? ask;
  String? change;
  String? changePercent;
  String? open;
  String? high;
  String? low;

  Data(
      {this.asset,
      this.last,
      this.bid,
      this.ask,
      this.change,
      this.changePercent,
      this.open,
      this.high,
      this.low});

  Data.fromJson(Map<String, dynamic> json) {
    asset = json['asset'];
    last = json['last'];
    bid = json['bid'];
    ask = json['ask'];
    change = json['change'];
    changePercent = json['changePercent'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['asset'] = asset;
    data['last'] = last;
    data['bid'] = bid;
    data['ask'] = ask;
    data['change'] = change;
    data['changePercent'] = changePercent;
    data['open'] = open;
    data['high'] = high;
    data['low'] = low;
    return data;
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:sahil_assignment/trade/try_screen.dart';
// import 'package:shimmer/shimmer.dart';
// import '../model/trade_model.dart';
// import 'package:http/http.dart' as http;
//
// class TradeChartPage extends StatefulWidget {
//   const TradeChartPage({super.key});
//
//   @override
//   TradeChartPageState createState() => TradeChartPageState();
// }
//
// class TradeChartPageState extends State<TradeChartPage> {
//   List<FlSpot> dataPoints = [];
//   Random random = Random();
//   late Timer updateTimer;
//   late Timer countdownTimer;
//   late Timer fetchTimer;
//   late double currentValue;
//   String _selectedOption = "EUR/USD";
//   int countdown = 30;
//   late Future<Data> futureTradeData;
//   bool _isLoading = true;
//   double askValue = 0.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _generateInitialData();
//     futureTradeData = fetchTradeData(_selectedOption);
//     updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
//       _updateData();
//     });
//
//     fetchTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
//       _fetchData();
//     });
//
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }
//
//   Future<Data> fetchTradeData(String selectedAsset) async {
//     try {
//       final response = await http
//           .get(Uri.parse('https://grandprimeforex.com:3000/fetch-data'))
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         Map<String, dynamic> jsonResponse = json.decode(response.body);
//         TradeModel model = TradeModel.fromJson(jsonResponse);
//         if (model.data != null && model.data!.isNotEmpty) {
//           Data selectedData = model.data!.firstWhere(
//                 (element) => element.asset == selectedAsset,
//             orElse: () =>
//             throw Exception('No data available for $selectedAsset'),
//           );
//           setState(() {
//             askValue = double.tryParse(selectedData.ask!) ?? 0.0;
//           });
//           return selectedData;
//         } else {
//           throw Exception('No data available');
//         }
//       } else {
//         throw Exception('Failed to load trade data');
//       }
//     } on TimeoutException {
//       throw Exception('Request timed out');
//     } on SocketException {
//       throw Exception('No Internet connection');
//     } catch (e) {
//       throw Exception('Unexpected error: $e');
//     }
//   }
//
//   Future<void> _fetchData() async {
//     setState(() {
//       futureTradeData = fetchTradeData(_selectedOption);
//     });
//   }
//
//   @override
//   void dispose() {
//     updateTimer.cancel();
//     countdownTimer.cancel();
//     fetchTimer.cancel();
//     super.dispose();
//   }
//
//   void _generateInitialData() {
//     currentValue = random.nextDouble() * 100 - 80;
//     for (int i = 0; i < 100; i++) {
//       dataPoints.add(FlSpot(i.toDouble(), currentValue));
//       _updateValue();
//     }
//   }
//
//   void _updateValue({double change = 0}) {
//     double randomChange = (random.nextDouble() - 0.5) * 5;
//     currentValue = (currentValue + change + randomChange).clamp(-80.0, 20.0);
//   }
//
//   void _updateData() {
//     setState(() {
//       _updateValue();
//       dataPoints.removeAt(0);
//       dataPoints.add(FlSpot(99, currentValue));
//       for (int i = 0; i < dataPoints.length; i++) {
//         dataPoints[i] = FlSpot(i.toDouble(), dataPoints[i].y);
//       }
//
//       // Update the ask value with a random increment or decrement
//       double randomChange = (random.nextDouble() - 0.5) * 0.1;
//       askValue += randomChange;
//       askValue = double.parse(
//           askValue.toStringAsFixed(3));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double chartHeight = MediaQuery.of(context).size.height - 180;
//     double yPosition = ((currentValue + 80) / 100) * chartHeight;
//
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.grey[900],
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: DropdownButton<String>(
//                     value: _selectedOption,
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _selectedOption = newValue!;
//                         futureTradeData = fetchTradeData(_selectedOption);
//                       });
//                     },
//                     dropdownColor: Colors.grey[850],
//                     style: const TextStyle(color: Colors.white),
//                     items: <String>[
//                       "EUR/USD",
//                       "GBP/USD",
//                       "USD/JPY",
//                       "USD/CHF",
//                     ].map<DropdownMenuItem<String>>((String value) {
//                       return DropdownMenuItem<String>(
//                         value: value,
//                         child: Text(value),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const HomeScreen(),
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 22),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[850],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Icon(Icons.person, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: _isLoading
//                       ? Shimmer.fromColors(
//                     baseColor: Colors.grey[800]!,
//                     highlightColor: Colors.grey[500]!,
//                     child: Container(
//                       height: 800,
//                       color: Colors.grey[850],
//                     ),
//                   )
//                       : Stack(
//                     children: [
//                       LineChart(
//                         LineChartData(
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: dataPoints,
//                               isCurved: true,
//                               color: Colors.blue,
//                               barWidth: 2,
//                               isStrokeCapRound: true,
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.blue.withOpacity(0.3),
//                                     Colors.transparent,
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                               dotData: const FlDotData(show: false),
//                               shadow: const Shadow(
//                                 color: Colors.black,
//                                 blurRadius: 5,
//                                 offset: Offset(0, 3),
//                               ),
//                             ),
//                           ],
//                           titlesData: FlTitlesData(
//                             rightTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 50,
//                                 getTitlesWidget: (value, meta) {
//                                   return Padding(
//                                     padding:
//                                     const EdgeInsets.only(left: 25),
//                                     child: Text(
//                                       value.toInt().toString(),
//                                       style: const TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             bottomTitles: const AxisTitles(
//                                 sideTitles:
//                                 SideTitles(showTitles: false)),
//                             leftTitles: const AxisTitles(
//                                 sideTitles:
//                                 SideTitles(showTitles: false)),
//                             topTitles: const AxisTitles(
//                                 sideTitles:
//                                 SideTitles(showTitles: false)),
//                           ),
//                           borderData: FlBorderData(show: false),
//                           gridData: FlGridData(
//                             show: true,
//                             drawVerticalLine: true,
//                             horizontalInterval: 15,
//                             verticalInterval: 35,
//                             getDrawingHorizontalLine: (value) {
//                               return FlLine(
//                                 color: Colors.white.withOpacity(0.1),
//                                 strokeWidth: 1,
//                               );
//                             },
//                             getDrawingVerticalLine: (value) {
//                               return FlLine(
//                                 color: Colors.white.withOpacity(0.1),
//                                 strokeWidth: 1,
//                               );
//                             },
//                           ),
//                           extraLinesData: ExtraLinesData(
//                             horizontalLines: [
//                               HorizontalLine(
//                                 y: currentValue,
//                                 color: Colors.white,
//                                 strokeWidth: 1,
//                               ),
//                             ],
//                           ),
//                           minX: 20,
//                           maxX: 130,
//                           minY: -100,
//                           maxY: 20,
//                         ),
//                       ),
//                       Positioned(
//                         right: 1,
//                         top: chartHeight - yPosition - 8,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             "Ask: ${askValue.toStringAsFixed(4)}",
//                             style: const TextStyle(
//                               color: Colors.black,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 25),
//           ],
//         ),
//       ),
//     );
//   }
// }
