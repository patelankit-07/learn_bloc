import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fl_chart/fl_chart.dart';

import '../model/trade_model.dart';
import 'package:http/http.dart' as http;
class TradeData{
  static Stream<List<FlSpot>?>? dataList;

 static getData(String selectedAsset) {
   Timer.periodic(Duration(seconds: 30), (timer) async{
     var data = await  fetchTradeData(selectedAsset);
     print("data  id hfg =>  ${data?.map((e) => e.toJson(),).toString()}");
     dataList =  Stream.value(data?.map((e) => FlSpot(double.parse(e.bid.toString()),double.parse(e.open.toString()) ),).toList());

   },);
  }
 static Future<List<Data>?> fetchTradeData(String selectedAsset) async {
    try {
      final response = await http
          .get(Uri.parse('https://grandprimeforex.com:3000/fetch-data'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        TradeModel model = TradeModel.fromJson(jsonResponse);
        if (model.data != null && model.data!.isNotEmpty) {
          return model.data;
        } else {
          throw Exception('No data available');
        }
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

}