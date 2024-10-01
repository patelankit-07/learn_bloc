import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sahil_assignment/model/trade_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<List<Data>> futureTradeData;
  late Timer updateTimer;

  @override
  void initState() {
    super.initState();
    futureTradeData = fetchTradeData();

    updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        futureTradeData = fetchTradeData();
      });
    });
  }

  @override
  void dispose() {
    updateTimer.cancel();
    super.dispose();
  }

  Future<List<Data>> fetchTradeData() async {
    try {
      final response = await http
          .get(Uri.parse('https://grandprimeforex.com:3000/fetch-data'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        TradeModel model = TradeModel.fromJson(jsonResponse);
        return model.data ?? [];
      } else {
        throw Exception('Failed to load trade data');
      }
    } on TimeoutException {
      throw Exception('Request timed out');
    } on SocketException {
      throw Exception('No Internet connection');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      futureTradeData = fetchTradeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Trade Data')),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Data>>(
          future: futureTradeData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text('No data available'));
            } else if (snapshot.hasData) {
              List<Data>? data = snapshot.data;
              return ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(data[index].asset ?? 'No Asset'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Last: ${data[index].last}'),
                          Text('Bid: ${data[index].bid}'),
                          Text('Ask: ${data[index].ask}'),
                          Text('Change: ${data[index].change}'),
                          Text('Change %: ${data[index].changePercent}'),
                          Text('Open: ${data[index].open}'),
                          Text('High: ${data[index].high}'),
                          Text('Low: ${data[index].low}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
