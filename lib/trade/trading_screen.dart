import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sahil_assignment/trade/try_screen.dart';
import '../model/trade_model.dart';
import 'package:http/http.dart' as http;

class TradeChartPage extends StatefulWidget {
  const TradeChartPage({super.key});

  @override
  TradeChartPageState createState() => TradeChartPageState();
}

class TradeChartPageState extends State<TradeChartPage> {
  List<FlSpot> dataPoints = [];
  Random random = Random();
  late Timer updateTimer;
  late Timer fetchTimer;
  late double currentValue;
  String _selectedOption = "EUR/USD";
  late Future<Data> futureTradeData;
  bool _isLoading = true;
  late String askValue = 'Loading...';

  @override
  void initState() {
    super.initState();
    askValue = 'Loading...'; // Assign a default value
    _generateInitialData();
    futureTradeData = fetchTradeData(_selectedOption);

    // Timer to update the graph data every 2 seconds
    updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateData();
    });

    // Timer to fetch new trade data every 30 seconds
    fetchTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        // Fetch new trade data
        futureTradeData = fetchTradeData(_selectedOption);
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    updateTimer.cancel();
    fetchTimer.cancel();
    super.dispose();
  }

  Future<Data> fetchTradeData(String selectedAsset) async {
    try {
      final response = await http
          .get(Uri.parse('https://grandprimeforex.com:3000/fetch-data'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        TradeModel model = TradeModel.fromJson(jsonResponse);
        if (model.data != null && model.data!.isNotEmpty) {
          return model.data!.firstWhere(
            (element) => element.asset == selectedAsset,
            orElse: () =>
                throw Exception('No data available for $selectedAsset'),
          );
        } else {
          throw Exception('No data available');
        }
      } else {
        throw Exception('Failed to load trade data');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  void _generateInitialData() {
    currentValue = random.nextDouble() * 100 - 80;
    for (int i = 0; i < 100; i++) {
      dataPoints.add(FlSpot(i.toDouble(), currentValue));
      _updateValue();
    }
  }

  void _updateValue({double change = 0}) {
    double randomChange = (random.nextDouble() - 0.5) * 5;
    currentValue = (currentValue + change + randomChange).clamp(-80.0, 20.0);
  }

  void _updateData() {
    setState(() {
      _updateValue();
      dataPoints.removeAt(0);
      dataPoints.add(FlSpot(99, currentValue));
      for (int i = 0; i < dataPoints.length; i++) {
        dataPoints[i] = FlSpot(i.toDouble(), dataPoints[i].y);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double chartHeight = MediaQuery.of(context).size.height - 180;
    double yPosition = ((currentValue + 80) / 100) * chartHeight;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedOption,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedOption = newValue!;
                        futureTradeData = fetchTradeData(_selectedOption);
                      });
                    },
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(color: Colors.white),
                    items: <String>[
                      "EUR/USD",
                      "GBP/USD",
                      "USD/JPY",
                      "USD/CHF",
                      "USD/CAD",
                      "AUD/USD",
                      "NZD/USD",
                      "USD/CNY",
                      "EUR/GBP",
                      "Dollar ...",
                      "SP 500",
                      "Nikkei ...",
                      "FTSE 10...",
                      "DAX",
                      "WTI US ...",
                      "XAU/USD",
                      "BTC/USD",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 22),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[850],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: _isLoading
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[800]!,
                          highlightColor: Colors.grey[500]!,
                          child: Container(
                            height: double.infinity,
                            color: Colors.grey[850],
                          ),
                        )
                      : Stack(
                          children: [
                            LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: dataPoints,
                                    isCurved: true,
                                    color: Colors.blue,
                                    barWidth: 2,
                                    isStrokeCapRound: true,
                                    belowBarData: BarAreaData(
                                      show: true,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.withOpacity(0.3),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    dotData: const FlDotData(show: false),
                                    shadow: const Shadow(
                                      color: Colors.black,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ),
                                ],
                                titlesData: FlTitlesData(
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 50,
                                      getTitlesWidget: (value, meta) {
                                        return Padding(
                                          padding: EdgeInsets.only(left: 9),
                                          child: Text(
                                            askValue,
                                            style:const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  bottomTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  leftTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: true,
                                  horizontalInterval: 15,
                                  verticalInterval: 35,
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.white.withOpacity(0.1),
                                      strokeWidth: 1,
                                    );
                                  },
                                  getDrawingVerticalLine: (value) {
                                    return FlLine(
                                      color: Colors.white.withOpacity(0.1),
                                      strokeWidth: 1,
                                    );
                                  },
                                ),
                                extraLinesData: ExtraLinesData(
                                  horizontalLines: [
                                    HorizontalLine(
                                      y: currentValue,
                                      color: Colors.white,
                                      strokeWidth: 1,
                                    ),
                                  ],
                                ),
                                minX: 20,
                                maxX: 130,
                                minY: -100,
                                maxY: 20,
                              ),
                            ),
                            FutureBuilder<Data>(
                              future: futureTradeData,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                  );
                                } else if (snapshot.hasData) {
                                  askValue = snapshot.data!.ask ??
                                      'No ask'; // Update the ask value here
                                  final bid = snapshot.data!.bid ?? 'No bid';
                                  return Stack(
                                    children: [
                                      Positioned(
                                        right: 1,
                                        top: chartHeight - yPosition,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            "ask: $askValue",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 10,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            "bid: $bid",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return const Text(
                                    'No data available',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  );
                                }
                              },
                            )
                          ],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
